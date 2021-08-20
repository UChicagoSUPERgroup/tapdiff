from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse, JsonResponse
from django.template import loader
import backend.models as m
from backend.utils import getCachedData, updateCachedData
import os, sys, itertools, json, re
from autotapmc.analyze.Fix import generateCompactFix, generateNamedFix
from autotapmc.diff.TimelineDiff import compareRules
from autotapmc.diff.SpDiff import compareSps
from autotapmc.diff.QuestionsDiff import compareMultipleVerRules
from autotapmc.model.Tap import Tap
from django.views.decorators.csrf import csrf_exempt
from autotap.translator import tap_to_frontend_view, translate_sp_to_autotap_ltl, \
    translate_rule_into_autotap_tap, generate_all_device_templates, backend_to_frontend_view, \
    clause_to_autotap_tap, autotap_diff_to_clause, autotap_formula_to_clause, get_number_of_options, \
    autotap_qdiff_to_clause
from autotap.testdata import property_user_task_list, rule_user_task_list, task_ltl_dict, \
    correct_property_user_task_list, mutated_rule_user_task_list, multiple_property_user_task_list
from backend.utils import get_or_make_user_init_rules
from sympy.logic import simplify_logic


def get_or_make_user(code, mode):
    try:
        user = m.User.objects.get(code=code, mode=mode)
    except m.User.DoesNotExist:
        user = m.User(code=code, mode=mode)
        user.save()

    return user


def get_user_id(user_id):
    n_code = False
    n_id = False
    try:
        user_id = m.User.objects.get(code=user_id).id
        return user_id
    except m.User.DoesNotExist:
        n_code = True
    try:
        user_id = m.User.objects.get(id=user_id).id
        return user_id
    except (m.User.DoesNotExist, ValueError):
        n_id = True

    if n_code and n_id:
        raise Exception("User %s does not exist." % str(user_id))


def trigger_to_clause(trigger, is_event):  # copied from backend/views :(
    c = {'channel': {'id': trigger.chan.id,
                     'name': trigger.chan.name,
                     'icon': trigger.chan.icon},
         'device': {'id': trigger.dev.id,
                    'name': trigger.dev.name},
         'capability': {'id': trigger.cap.id,
                        'name': trigger.cap.name,
                        'label': (trigger.cap.eventlabel if is_event else trigger.cap.statelabel)},
         'text': trigger.text,
         'id': trigger.pos}
    conds = m.Condition.objects.filter(trigger=trigger).order_by('id')
    if conds != []:
        c['parameters'] = []
        c['parameterVals'] = []

        for cond in conds:
            c['parameters'].append({'id': cond.par.id,
                                    'name': cond.par.name,
                                    'type': cond.par.type})
            c['parameterVals'].append({'comparator': cond.comp,
                                       'value': cond.val})
    return c


def state_to_clause(state):  # copied from backend/views :(
    c = {'channel': {'id': state.chan.id,
                     'name': state.chan.name,
                     'icon': state.chan.icon},
         'device': {'id': state.dev.id,
                    'name': state.dev.name},
         'capability': {'id': state.cap.id,
                        'name': state.cap.name,
                        'label': state.cap.commandlabel},
         'text': state.text}

    cap = m.Capability.objects.get(id=state.cap.id)
    par_list = m.Parameter.objects.filter(cap_id=cap.id)
    par_dict = dict()
    for par in par_list:
        par_c = dict()
        par_c['id'] = par.id
        par_c['type'] = par.type
        par_c['name'] = par.name
        if par.type == 'bin':
            bin_par = m.BinParam.objects.get(id=par.id)
            par_c['value_list'] = [bin_par.fval, bin_par.tval]
            t_template = r'\{%s/T\|(?P<value>[\w &\-]+)\}' % par.name
            f_template = r'\{%s/F\|(?P<value>[\w &\-]+)\}' % par.name
            t_val = re.search(t_template, cap.commandlabel)
            f_val = re.search(f_template, cap.commandlabel)
            if t_val and f_val:
                par_c['value_list_in_statement'] = [
                    f_val.group('value'), t_val.group('value')]
            else:
                par_c['value_list_in_statement'] = par_c['value_list'] = [
                    bin_par.fval, bin_par.tval]
        elif par.type == 'range':
            par_c['value_list'] = []
        elif par.type == 'set':
            par_c['value_list'] = [
                opt.value for opt in m.SetParamOpt.objects.filter(param_id=par.id)]
        else:
            raise Exception('var type %s not supported' % par.type)

        par_dict[par.name] = par_c
    template_text = cap.commandlabel.replace('(', '\(')
    template_text = template_text.replace(')', '\)')
    template_text = re.sub(r'\{DEVICE\}', state.dev.name, template_text)
    template_text = re.sub(
        r'\{(\w+)/(T|F)\|[\w &\-]+\}\{\1/(T|F)\|[\w &\-]+\}', r'(?P<\1>[\w &\-]+)', template_text)
    template_text = re.sub(r'\{(\w+)\}', r'(?P<\1>[\w &\-]+)', template_text)
    re_mat = re.match(template_text, state.text)

    for par, par_c in par_dict.items():
        par_dict[par_c['name']]['value'] = re_mat.group(par_c['name'])

    c['parameters'] = [{'type': par_c['type'], 'name': par_c['name'], 'id': par_c['id']}
                       for par, par_c in sorted(par_dict.items())]
    c['parameterVals'] = list()
    for par, par_c in sorted(par_dict.items()):
        if par_c['type'] == 'bin':
            value = par_c['value_list'][par_c['value_list_in_statement'].index(
                par_c['value'])]
        else:
            value = par_c['value']
        c['parameterVals'].append({'comparator': '=', 'value': value})

    return c


##################################################
###### Outcome-Diff: Flowcharts (tdiff) ##########
##################################################

def diff_helper(kwargs):
    json_resp = dict()

    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'], 'rules')
        json_resp['userid'] = user.id

    task = kwargs['taskid']
    ver_1 = kwargs['version1']
    ver_2 = kwargs['version2']

    if ver_1 == ver_2:
        json_resp['diff'] = []
        json_resp['num_opts'] = {}
        return json_resp

    rule_set_ver_1 = list()
    rule_set_ver_2 = list()

    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_1).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t, True))
        for t in sorted(rule.Striggers.all(), key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t, False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_1.append({'id': rule.id,
                               'ifClause': ifclause,
                               'thenClause': [thenclause],
                               'temporality': 'event-state'})

    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_2).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t, True))
        for t in sorted(rule.Striggers.all(), key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t, False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_2.append({'id': rule.id,
                               'ifClause': ifclause,
                               'thenClause': [thenclause],
                               'temporality': 'event-state'})

    try:
        rule_clause_list_1 = rule_set_ver_1
        rule_clause_list_2 = rule_set_ver_2

        rule_list_1 = [clause_to_autotap_tap(
            clause) for clause in rule_clause_list_1]
        rule_list_2 = [clause_to_autotap_tap(
            clause) for clause in rule_clause_list_2]

        template_dict = generate_all_device_templates()
        diff_result = compareRules(
            rule_list_1, rule_list_2, template_dict, task, ver_1, ver_2)

        json_resp['succeed'] = True
        json_resp['diff'] = [autotap_diff_to_clause(
            e, c, b) for (e, c, b) in diff_result]  # diff_result
        if json_resp['diff']:
            conditions = json_resp['diff'][0]['condition']
            num_opts = {cond['device']['name'] + ': ' + cond['capability']
                        ['name']: get_number_of_options(cond) for cond in conditions}
            json_resp['num_opts'] = num_opts
        else:
            json_resp['num_opts'] = {}
    except Exception as exc:
        json_resp['succeed'] = False
        json_resp['fail_exc'] = str(exc)

    return json_resp


def diff(request):  # timeline diff
    kwargs = json.loads(request.body.decode('utf-8'))
    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'], 'rules')

    task = kwargs['taskid']
    ver_1 = kwargs['version1']
    ver_2 = kwargs['version2']

    # cachedData = getCachedData(task, user, ver_1, ver_2, "timelinediff")
    cachedData=None # tmp
    if cachedData != None:
        json_resp = cachedData
    else:
        json_resp = diff_helper(kwargs)

    json_resp['userid'] = user.id
    return JsonResponse(json_resp)


##################################################
####### Outcome-Diff: Questions (qdiff) ##########
##################################################

def compareMultipleVers(user, task, ver_list):
    ver_rules_list = []
    for ver in ver_list:
        ver_rules_list.append([
            translate_rule_into_autotap_tap(rule)
            for rule in m.Rule.objects.filter(owner=user, task=task, version=ver).order_by('id')])
    template_dict = generate_all_device_templates()
    diff_result = compareMultipleVerRules(
        ver_rules_list, ver_list, template_dict, task=task)
    return diff_result


def compareVers(user, task, ver_1, ver_2):
    succeed = True
    rule_set_ver_1 = list()
    rule_set_ver_2 = list()

    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_1).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t, True))
        for t in sorted(rule.Striggers.all(), key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t, False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_1.append({'id': rule.id,
                               'ifClause': ifclause,
                               'thenClause': [thenclause],
                               'temporality': 'event-state'})

    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_2).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t, True))
        for t in sorted(rule.Striggers.all(), key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t, False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_2.append({'id': rule.id,
                               'ifClause': ifclause,
                               'thenClause': [thenclause],
                               'temporality': 'event-state'})

    try:
        rule_clause_list_1 = rule_set_ver_1
        rule_clause_list_2 = rule_set_ver_2
        rule_list_1 = [clause_to_autotap_tap(
            clause) for clause in rule_clause_list_1]
        rule_list_2 = [clause_to_autotap_tap(
            clause) for clause in rule_clause_list_2]

        template_dict = generate_all_device_templates()
        diff_result = compareRules(
            rule_list_1, rule_list_2, template_dict, task, ver_1, ver_2)
        diff = [autotap_diff_to_clause(e, c, b)
                for (e, c, b) in diff_result]  # diff_result

    except Exception as exc:
        succeed = False
        diff = str(exc)

    return (succeed, diff)


def getStartKey(diff):
    start_key = ' & '.join(sorted(x['text'] for x in diff['condition']))
    start_key += ': '+diff['event']['text']
    return start_key


def getChoices(diff):
    choice1 = '(Nothing)' if not diff['behavior1'] else ', '.join(
        sorted([beh['text'] for beh in diff['behavior1']]))
    choice2 = '(Nothing)' if not diff['behavior2'] else ', '.join(
        sorted([beh['text'] for beh in diff['behavior2']]))
    return (choice1, choice2)


def getMultiChoices(diff, all_vers):
    def text_editor(beh): return '(Nothing)' if not beh \
        else ', '.join(sorted(b['text'] for b in beh))
    behavior_text_list = [text_editor(beh) for beh in diff['behavior_list']]
    choice_list = []
    behavior_list = []
    vers_list = []
    for orig_beh, beh, ver in zip(diff['behavior_list'], behavior_text_list, all_vers):
        if beh not in choice_list:
            choice_list.append(beh)
            behavior_list.append(orig_beh)
            vers_list.append([ver])
        else:
            ii = choice_list.index(beh)
            vers_list[ii].append(ver)

    return behavior_list, vers_list


# In order of ops
question_mark_replacement = '_' * 5
dev_cap_separator = '_' * 4
spaces_replacement = '_' * 3
slash_replacement = '_' * 2
set_cap_val_separator = '_'
def getDiffGroupI(diff_groups, d):
    for i in range(len(diff_groups)):
        diff_group_member = diff_groups[i]
        sameBehaviors = False
        diff_group_behaviors = diff_group_member[2] # list of subbehaviors (also lists)
        if len(diff_group_behaviors) == len(d['behaviors']):
            for b in range(len(d['behaviors'])):  # jesus there are subbehaviors
                if d['behaviors'][b] == [] and diff_group_behaviors[b] == []:
                    sameBehaviors = True
                elif len(d['behaviors'][b]) == len(diff_group_behaviors[b]):
                    # could be a dict o
                    if all([d['behaviors'][b][bb]['text'] == diff_group_behaviors[b][bb]['text'] for bb in range(len(d['behaviors'][b]))]):
                        sameBehaviors = True

        if not sameBehaviors:
            continue

        sameEvent = diff_group_member[0]['text'] == d['event']['text']
        sameVers = diff_group_member[1] == d['vers']
        if sameBehaviors and sameEvent and sameVers:
            return i
    assert(False), d
    return None


def getDiffCondI(diff_conds_member, simp_cond_info, true_states):
    for diff_cond_i in range(len(diff_conds_member)):
        # need to flatten diff_conds_member first because now we don't care which situation we got a group of conds from
        diff_cond = diff_conds_member[diff_cond_i]
        for cond_i in range(len(diff_cond)):
            cond = diff_cond[cond_i]
            if set_cap_val_separator in simp_cond_info[1]:
                if cond['parameters'][0]['type']=='bin':
                    continue
                [cap, val] = simp_cond_info[1].split(set_cap_val_separator)
                if cond['device']['name'] == simp_cond_info[0] and cond['capability']['name'] == cap and cond['parameterVals'][0]['value']==val:
                    return (diff_cond_i, cond_i)
            elif cond['device']['name'] == simp_cond_info[0] and cond['capability']['name'] == simp_cond_info[1]:
                if simp_cond_info[2] and cond['parameterVals'][0]['value'].lower() in true_states:
                    return (diff_cond_i, cond_i)
                if (not simp_cond_info[2]) and (cond['parameterVals'][0]['value'].lower() not in true_states):
                    return (diff_cond_i, cond_i)
    assert(False), simp_cond_info
    return None


def condenseQdiff(diff_list):
    # GOAL: to condense situations of the same event, vers, and behaviors by simplifying the conditions
    # 1. make two lists: one has the (unique) tuples of (events, vers, behaviors), while the other has
    # (in the same order) the nested list of conditions (one list per situation corresponding to the tuple)
    # 2. simplify the conditions in the second list
    # 3. stitch the situations back together from the two lists

    diff_groups, diff_conds = [], []
    for d in diff_list:
        diff_group_member = (d['event'], d['vers'], d['behaviors'])
        diff_conds_member = d['condition']
        if diff_group_member not in diff_groups:
            diff_groups.append(diff_group_member)
            diff_conds.append([diff_conds_member])
        else:
            # do nothing to diff_groups, but find the right spot
            diff_conds[getDiffGroupI(diff_groups, d)].append(diff_conds_member)
    true_states = ['awake', 'on', 'open', 'lock', 'raining', 'day'] # This is unfortunately a hack

    simp_diff_conds = []
    for situation in diff_conds:
        situation_exprs = []
        # assumes no duplicates in each situation/dev
        for conds in situation:
            conds_expr = []
            for cond in conds:
                dev_name = cond['device']['name'].replace(' ', spaces_replacement)
                cap_name = cond['capability']['name'].replace('/', slash_replacement).replace('?', question_mark_replacement).replace(' ', spaces_replacement)
                # assume single-item list for now because boolean locations
                state = cond['parameterVals'][0]['value']
                # replace space with __ and '/' with _
                cond_expr = dev_name+dev_cap_separator+cap_name

                if cond['parameters'][0]['type']!='bin':
                    cond_expr += set_cap_val_separator + state.replace(' ', spaces_replacement)
                else:
                    if state.lower() not in true_states:
                        cond_expr = '~'+cond_expr
                conds_expr.append(cond_expr)
            situation_exprs.append('(' + ' & '.join(conds_expr) + ')')
        boolean_expr = ' | '.join(situation_exprs)  # | is between situations
        # TODO: will it ever be necessary to check the end states and exclude them from being factored out?
        simp_expr = str(simplify_logic(boolean_expr, 'dnf'))
        simp_conds = [x.strip('(').strip(')').split(' & ') for x in simp_expr.split(' | ')] # should be nested again
        simp_diff_conds.append(simp_conds) # simp_diff_conds = [[[]]

    final_situations = []
    for s in range(len(diff_groups)):
        situation_conds = []
        simp_diff_cond = simp_diff_conds[s] # [[]]
        for simp_conds in simp_diff_cond: # []
            # now need to look for conds...
            specific_situation_conds = [] # list of dicts
            for simp_cond in simp_conds: # str
                state = not (simp_cond[0] == '~')
                # preprocessing
                simp_cond = simp_cond.replace(question_mark_replacement, '?')
                [dev, cap] = simp_cond.split(dev_cap_separator)
                dev_name = dev.strip('~').replace(spaces_replacement, ' ')
                cap_name = cap.replace(spaces_replacement, ' ').replace(slash_replacement, '/') # includes set_cap_val_separator if not binary
                simp_cond_info = (dev_name, cap_name, state)
                [diff_cond_i, diff_conds_member_i] = getDiffCondI(diff_conds[s], simp_cond_info, true_states)
                specific_situation_conds.append(diff_conds[s][diff_cond_i][diff_conds_member_i]) # dict
            situation_conds.append(specific_situation_conds)
        for specific_situation_conds in situation_conds:
            situation = {}
            situation['event'] = diff_groups[s][0]
            situation['vers'] = diff_groups[s][1]
            situation['behaviors'] = diff_groups[s][2]
            situation['condition'] = specific_situation_conds
            final_situations.append(situation)
    return final_situations


def qdiff_helper(kwargs):
    ''' This function should return something to the effect of:
    - a dictionary with the questions mapped to the choices;
    - a dictionary that allows frontend to search for the right version id based on a set of choices '''
    # With this simple algr:
    # Backend: sends a list of questions to ask (conditions + trigger events): json_resp['diff]
    # with the choices and the version ids they map to
    # Frontend: calculates the right version id based on the responses

    json_resp = dict()
    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'], 'rules')
        json_resp['userid'] = user.id

    task = kwargs['taskid']

    all_vers = kwargs['verids']  # unique and sorted
    # task_type = kwargs['tasktype']
    all_diff = compareMultipleVers(user, task, all_vers)

    new_diff_list = []
    for e, c, bl in all_diff:
        diff = autotap_qdiff_to_clause(e, c, bl, all_vers)
        choices, vers = getMultiChoices(diff, all_vers)
        del diff['behavior_list']
        diff['behaviors'] = choices
        diff['vers'] = vers
        new_diff_list.append(diff)

    json_resp['succeed'] = True
    json_resp['diff'] = condenseQdiff(new_diff_list) # replace with new_diff_list if not factoring

    return json_resp


def qdiff(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'], 'rules')

    task = kwargs['taskid']

    # cachedData = getCachedData(task, user, 0, 0, "questionsdiff")
    cachedData=None # tmp
    if cachedData != None:
        json_resp = cachedData
    else:
        json_resp = qdiff_helper(kwargs)

    json_resp['userid'] = user.id
    # updateCachedData(json_resp, task, user, 0, 0, page="questionsdiff")

    return JsonResponse(json_resp)


##################################################
########### Properties Diff (spdiff) #############
##################################################

def display_trigger(trigger):
    return {'channel': {'icon': trigger['channel']['icon']}, 'text': trigger['text']}


def convert_sp(sp_dict):  # modified from backend/views.py/fe_all_sps()
    if sp_dict['type'] == 1:  # [this state] and [that state] should always/never occur together
        # sp1 = sp.sp1
        triggers = sp_dict['clauses']  # sp1.triggers.all().order_by('pos')
        thisstate = triggers[0]
        try:
            thatstate = list(map(display_trigger, triggers[1:]))
        except IndexError:
            thatstate = []

        return {'thisState': [display_trigger(thisstate)],
                'thatState': thatstate,
                'compatibility': sp_dict['always'],
                'status': sp_dict['status']}

    elif sp_dict['type'] == 2:  # [this state] should always/never be active
        json2 = {'stateClause': [display_trigger(sp_dict['clauses'][0])],
                 'compatibility': sp_dict['always'], 'status': sp_dict['status']}
        # if sp2.comp:
        #     json2['comparator'] = sp2.comp
        # if sp2.time != None:
        #     json2['time'] = int_to_time(sp2.time)

        clauses = sp_dict['clauses'][1:]  # sp2.conds.all().order_by('pos')
        if clauses != []:
            json2['alsoClauses'] = list(map(display_trigger, clauses))
        else:
            json2['alsoClauses'] = []
        return json2

    elif sp_dict['type'] == 3:  # [this event] should always/never happen
        json3 = {'triggerClause': [display_trigger(sp_dict['clauses'][0])],
                 'compatibility': sp_dict['always'], 'status': sp_dict['status']}

        # if sp3.comp:
        #     json3['comparator'] = sp3.comp
        # if sp3.occurrences != None:
        #     json3['times'] = sp3.occurrences

        clauses = sp_dict['clauses'][1:]  # sp3.conds.all().order_by('pos')
        if clauses != []:
            json3['otherClauses'] = list(map(display_trigger, clauses))

        # if sp3.time != None:
        #     if sp3.timecomp != None:
        #         json3['afterTime'] = int_to_time(sp3.time)
        #         json3['timeComparator'] = sp3.timecomp
        #     else:
        #         json3['withinTime'] = int_to_time(sp3.time)

        return json3


def changeSpFormat(single_diff_result):
    ''' This translates the iot-autotap/diff/SpDiff representation of each sp into something the frontend can use.'''
    if single_diff_result == []:
        return []

    res_json = []
    for res in single_diff_result:  # sp_dict = a single sp
        sp_dict = res[0]
        # autotap_formula_to_clause flag: 0 = state, 1 = event
        sp_clauses = []
        if sp_dict['type'] in [1, 2]:
            sp_clauses = [autotap_formula_to_clause(
                cap, 0) for cap in sp_dict['caps']]
        else:  # sp_dict = 3
            for cap_i in range(len(sp_dict['caps'])):
                cap = sp_dict['caps'][cap_i]
                if cap_i == 0:
                    sp_clauses.append(autotap_formula_to_clause(
                        cap, 1))  # first thing is event
                else:
                    sp_clauses.append(autotap_formula_to_clause(
                        cap, 0))  # rest are states
        sp_dict['clauses'] = sp_clauses
        sp_json = convert_sp(sp_dict)
        if len(res) == 2:
            # res[1] = rule_inds that correspond to the sp
            res_json.append((sp_json, res[1]))
        else:  # len(res)==3 for shared sps
            # res[1] = left_rule_inds, res[2] = right_rule_inds
            res_json.append((sp_json, res[1], res[2]))
    return res_json


def alignDifSps(spdiff_output):
    '''spdiff_output = (left_only_sps, right_only_sps, both_sps)'''
    (left_only_sps, right_only_sps, both_sps) = spdiff_output
    left_type_sps, right_type_sps = {}, {}
    for s in left_only_sps:
        k = s[0]['type']
        if k not in left_type_sps:
            left_type_sps[k] = []
        left_type_sps[k].append(s)
    for s in right_only_sps:
        k = s[0]['type']
        if k not in right_type_sps:
            right_type_sps[k] = []
        right_type_sps[k].append(s)
    shared_types = set(left_type_sps.keys()) & set(right_type_sps.keys())

    # Indicate whether a rule or a clause was deleted, added, shared, or changed.
    DEL_CODE = -1
    SHARE_CODE = 0
    ADD_CODE = 1
    PARTIAL_DEL_CODE = 21
    PARTIAL_ADD_CODE = 22

    # first assign pairingCodes, then statuses to unshared sps
    for t in shared_types:
        pairingCode = 0
        for i in range(min(len(left_type_sps[t]), len(right_type_sps[t]))):
            left_type_sps[t][i][0]['pairingCode'] = pairingCode
            left_type_sps[t][i][0]['status'] = PARTIAL_DEL_CODE
            right_type_sps[t][i][0]['pairingCode'] = pairingCode
            right_type_sps[t][i][0]['status'] = PARTIAL_ADD_CODE
            pairingCode+=1
    for l in left_only_sps:
        l[0]['status'] = DEL_CODE
    for r in right_only_sps:
        r[0]['status'] = ADD_CODE
    for b in both_sps:
        b[0]['status'] = SHARE_CODE
    return spdiff_output


def spdiff_helper(kwargs):
    json_resp = dict()
    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'], 'rules')
        json_resp['userid'] = user.id

    task = kwargs['taskid']
    ver_1 = kwargs['version1']
    ver_2 = kwargs['version2']

    rule_set_ver_1 = list()
    rule_set_ver_2 = list()

    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_1).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t, True))
        for t in sorted(rule.Striggers.all(), key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t, False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_1.append({'id': rule.id,
                               'ifClause': ifclause,
                               'thenClause': [thenclause],
                               'temporality': 'event-state'})

    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_2).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t, True))
        for t in sorted(rule.Striggers.all(), key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t, False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_2.append({'id': rule.id,
                               'ifClause': ifclause,
                               'thenClause': [thenclause],
                               'temporality': 'event-state'})

    try:
        rule_clause_list_1 = rule_set_ver_1
        rule_clause_list_2 = rule_set_ver_2

        rule_list_1 = [clause_to_autotap_tap(
            clause) for clause in rule_clause_list_1]  # like tap_lists
        rule_list_2 = [clause_to_autotap_tap(clause)
                       for clause in rule_clause_list_2]

        template_dict = generate_all_device_templates()
        diff_result = compareSps(rule_list_1, rule_list_2, template_dict, task, ver_1, ver_2)
        diff_result_aligned = alignDifSps(diff_result)

        # [for sps unique to TAP 1, TAP2, shared by both]
        result = [changeSpFormat(x) for x in diff_result_aligned]

        json_resp['succeed'] = True
        json_resp['diff'] = result

        # updateCachedData(json_resp, task, user, ver_1, ver_2, "spdiff")
    except Exception as exc:
        json_resp['succeed'] = False
        json_resp['fail_exc'] = str(exc)

    return json_resp


def spdiff(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'], 'rules')

    task = kwargs['taskid']
    ver_1 = kwargs['version1']
    ver_2 = kwargs['version2']

    # cachedData = getCachedData(task, user, ver_1, ver_2, "spdiff")
    cachedData=None # tmp
    if cachedData != None:
        json_resp = cachedData
    else:
        json_resp = spdiff_helper(kwargs)
    json_resp['userid'] = user.id
    return JsonResponse(json_resp)
