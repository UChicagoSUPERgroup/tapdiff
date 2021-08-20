from django.http import HttpRequest, HttpResponse, JsonResponse
from django.template import loader
from . import models as m
from .utils import getCachedData, updateCachedData, get_or_make_user_init_rules
from django.db.models import Q
import datetime, random
import operator as op
from django.views.decorators.csrf import csrf_exempt, ensure_csrf_cookie
import json
import re
from .textdiff import compare_rules_text
import sys, os
######################################
######################################
## INDEX                            ##
## FES :: FRONTEND / SELECTORS      ##
## STV :: ST-END VIEWS              ##
## RC  :: RULE CREATION             ##
######################################
######################################


################################################################################
## [FES] FRONTEND / SELECTORS
################################################################################

def get_or_make_user(code,mode):
    try:
        user = m.User.objects.get(code=code, mode=mode)
    except m.User.DoesNotExist:
        user = m.User(code=code, mode=mode)
        user.save()

    return user


def fe_all_users(request:HttpRequest):
    users = m.User.objects.all()
    json_users = []
    for user in users:
        rules = m.Rule.objects.filter(owner=user)
        tasks = []
        for rule in rules:
            tasks.append(rule.task)
        tasks = list(set(tasks))
        tasks.sort()
        json_users.append({"code":user.code, "id": user.id, "tasks": tasks})
    return JsonResponse({"users":json_users, "userCount": users.count()})


def fe_tasks_get(request:HttpRequest):
    kwargs = json.loads(request.body.decode('utf-8'))
    # create init user
    u = get_or_make_user(kwargs['code'], 'rules')
    rules = m.Rule.objects.filter(owner=u)
    tasks = []
    for rule in rules:
        tasks.append(rule.task)

    tasks = list(set(tasks))
    json_resp = {'userid' : dest_u.id, 'taskids': tasks}
    return JsonResponse(json_resp)


def fe_tasks_clear(request:HttpRequest):
    '''
    need
    code: string (identify the user)
    tasks: string/string[]  (optional. if no tasks, all rules will be cleared)
    '''
    kwargs = json.loads(request.body.decode('utf-8'))
    # create init user
    u = get_or_make_user(kwargs['code'], 'rules')

    # get task_ids that need to delete.
    task_ids = []
    if 'tasks' in kwargs:
        task_ids = kwargs['tasks']
        if not isinstance(task_ids, list):
            task_ids = [task_ids]
        
        for task_id in task_ids:
            rules = m.Rule.objects.filter(owner=u, task=task_id)
            for rule in rules:
                fe_delete_rule_core({"ruleid": rule.id, "userid": u.id})
    else:
        # clear all rules in this user
        rules = m.Rule.objects.filter(owner=u)
        for rule in rules:
            fe_delete_rule_core({"ruleid": rule.id, "userid": u.id})

    json_resp = {'userid' : u.id}
    return JsonResponse(json_resp)

def fe_tasks_copy(request:HttpRequest):
    '''
    need
    src_user_code:  string
    dest_user_code: string
    tasks:          list

    work
    copy tasks from src user to dest user.
    '''
    kwargs = json.loads(request.body.decode('utf-8'))
    print("# fe_tasks_copy: " + str(kwargs))
    # get src and dest user
    src_u = get_or_make_user(kwargs['src_user_code'], 'rules')
    dest_u = get_or_make_user(kwargs['dest_user_code'], 'rules')

    # get task_ids that need copy. 
    task_ids = kwargs['tasks']

    # copy all rules in this user.
    for task_id in task_ids:
        tmp_resp = fe_get_version_ids_core({"userid": src_u.id, "code": src_u.code, "taskid": task_id})
        version_ids = tmp_resp['version_ids']
        for version_id in version_ids:
            tmp_resp = fe_all_rules_core({"userid": src_u.id, "code":src_u.code, "taskid": task_id, "version": version_id})
            for rule_json in tmp_resp["rules"]:
                full_rule_json = fe_get_full_rule_core({"ruleid": rule_json['id']})
                # print("# full_rule_json", full_rule_json, file=sys.stderr)
                fe_create_esrule_core({"rule": full_rule_json['rule'], "mode": "create", "userid": dest_u.id, "taskid": task_id, "version": version_id}, forcecreate=True)

    json_resp = {'userid' : dest_u.id}
    return JsonResponse(json_resp)


def fe_taskversions_delete(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    u = get_or_make_user(kwargs['code'], 'rules')
    taskvers = kwargs['task_vers']
    
    for taskver in taskvers:
        taskid = taskver[0]
        verid = taskver[1]
        rules = None
        if verid == '*':
            rules = m.Rule.objects.filter(owner=u, task=taskid)
        else:
            rules = m.Rule.objects.filter(owner=u, task=taskid, version=verid)
        for rule in rules:
            fe_delete_rule_core({"ruleid": rule.id, "userid": u.id})
    
    json_resp = {'userid' : u.id}
    return JsonResponse(json_resp)


def fe_taskversions_copy(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    u = get_or_make_user(kwargs['code'], 'rules')
    src_ver = kwargs['src_ver']
    dest_vers = kwargs['dest_vers']

    rule_ids = []
    rules = m.Rule.objects.filter(owner=u, task=src_ver[0], version=src_ver[1])
    for rule in rules:
        rule_ids.append(rule.id)
    
    print("# fe_taskversions_copy src rule_ids:", str(rule_ids))

    # copy all rules in this user.
    for dest_ver in dest_vers:
        task_id = dest_ver[0]
        version_id = dest_ver[1]
        for rule_id in rule_ids:
            full_rule_json = fe_get_full_rule_core({"ruleid": rule_id})
            fe_create_esrule_core({"rule": full_rule_json['rule'], "mode": "create", "userid": u.id, "taskid": task_id, "version": version_id}, forcecreate=True)

    json_resp = {'userid' : u.id}
    return JsonResponse(json_resp)


def fe_get_user(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    u = get_or_make_user(kwargs['code'],kwargs['mode'])
    json_resp = {'userid' : u.id}
    return JsonResponse(json_resp)


# FRONTEND VIEW
def fe_all_rules(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    return JsonResponse(fe_all_rules_core(kwargs))

def fe_all_rules_core(kwargs):
    # userid, code, taskid, version?=0
    json_resp = {'rules' : []}
    
    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user(kwargs['code'],'rules')
        json_resp['userid'] = user.id

    task = kwargs['taskid']
    version = kwargs['version'] if 'version' in kwargs else 0

    for rule in m.Rule.objects.filter(owner=user, task=task, version=version).order_by('id'):
        if rule.type == 'es':
            ifclause = []
            t = rule.esrule.Etrigger
            ifclause.append({'channel' : {'icon' : t.chan.icon},
                             'text' : t.text})
            for t in sorted(rule.esrule.Striggers.all(),key=lambda x: x.pos):
                ifclause.append({'channel' : {'icon' : t.chan.icon},
                                 'text' : t.text})
            a = rule.esrule.action
            thenclause = [{'channel' : {'icon' : a.chan.icon if not (a.chan == None) else ''},
                           'text' : a.text}]

            json_resp['rules'].append({'id' : rule.id,
                                       'ifClause' : ifclause,
                                       'thenClause' : thenclause,
                                       'temporality' : 'event-state'})

    return json_resp



def write_user_operation_log(response_json):
    if False:
        print("# write_user_operation_log debug: ")
        for log_item in response_json['operation_log']:
            print("    " + log_item)
    file_name = response_json['code'] + "-" + response_json['task_id'] + "-" + str(datetime.datetime.now().timestamp()) + ".json"
    file_name = "/home/iftttuser/data-userlog/" + file_name
    file_content = json.dumps(response_json, indent=2)
    try:
        with open(file_name, 'w') as f:
            f.write(file_content)
    except IOError as error:
        print("# write_user_operation_log failed. print on screen.", file=sys.stderr)
        print("# ERROR detail:", error, file=sys.stderr)
        print("# filename:", file_name)
        print("# file content:", file_content)
        print("# filename (stderr):", file_name, file=sys.stderr)
        print("# file content (stderr):", file_content, file=sys.stderr)

# For selecting version
def fe_select_version(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    code = kwargs['code']
    task_id = kwargs['task_id']
    select_versions = kwargs['selected_versions']
    time_elapsed = kwargs['time_elapsed']
    write_user_operation_log(kwargs)

    user = get_or_make_user(code, 'rules')

    try:
        user_sel_log = m.UserSelection.objects.get(owner=user, task=task_id)
        user_sel_log.selection = select_versions
        user_sel_log.time_elapsed = time_elapsed
        user_sel_log.save()
    except (KeyError, m.UserSelection.DoesNotExist):
        user_sel_log = m.UserSelection.objects.create(owner=user, task=task_id, selection=select_versions, time_elapsed=time_elapsed)

    return JsonResponse({})


def fe_compare_rules_helper(kwargs):
    json_resp = {'diff' : []}
    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'],'rules')
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
        ifclause.append(trigger_to_clause(t,True))
        for t in sorted(rule.Striggers.all(),key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t,False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_1.append({'id' : rule.id,
                               'ifClause' : ifclause,
                               'thenClause' : [thenclause],
                               'temporality' : 'event-state'})
    for rule in m.Rule.objects.filter(owner=user, task=task, version=ver_2).order_by('id'):
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t,True))
        for t in sorted(rule.Striggers.all(),key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t,False))

        a = rule.action
        thenclause = state_to_clause(a)
        rule_set_ver_2.append({'id' : rule.id,
                               'ifClause' : ifclause,
                               'thenClause' : [thenclause],
                               'temporality' : 'event-state'})
    json_resp['diff'] = compare_rules_text(rule_set_ver_1, rule_set_ver_2)
    # updateCachedData(json_resp, task, user, ver_1, ver_2, "textdiff")
    # print(json_resp['diff'])
    return json_resp


# For code diff
def fe_compare_rules(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'],'rules')

    task = kwargs['taskid']
    ver_1 = kwargs['version1']
    ver_2 = kwargs['version2']
    # cachedData = getCachedData(task, user, ver_1, ver_2, "textdiff")
    cachedData=None # tmp
    if cachedData != None:
        json_resp = cachedData
    else:
        json_resp = fe_compare_rules_helper(kwargs)
    
    json_resp['userid'] = user.id
    
    return JsonResponse(json_resp)


def fe_get_version_programs(request):
    '''
    return {"version_ids":[...], "programs": {verid:{"rules":[...], ...}, ... }}
    '''
    kwargs = json.loads(request.body.decode('utf-8'))
    result_json = fe_get_version_ids_core(kwargs)
    id_list = result_json['version_ids']
    result_json["programs"] = dict()
    for verid in id_list:
        kwargs["version"] = verid
        result_json["programs"][verid] = fe_all_rules_core(kwargs)
    return JsonResponse(result_json)
        

def fe_get_version_ids(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    return JsonResponse(fe_get_version_ids_core(kwargs))

def fe_get_version_ids_core(kwargs):
    # userid, code, taskid
    json_resp = {'diff' : []}
    try:
        user = m.User.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user_init_rules(kwargs['code'],'rules')
        json_resp['userid'] = user.id
    
    task = kwargs['taskid']

    all_versions = m.Rule.objects.filter(owner=user, task=task)
    json_resp['version_ids'] = sorted(set([r.version for r in all_versions]))
    return json_resp


def fe_get_full_rule(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    return JsonResponse(fe_get_full_rule_core(kwargs))

def fe_get_full_rule_core(kwargs):
    json_resp = {}
    rule = m.Rule.objects.get(id=kwargs['ruleid'])
 
    if rule.type == 'es':
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t,True))
        for t in sorted(rule.Striggers.all(),key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t,False))
        a = rule.action
        # print("# fe_get_full_rule_core:", a, file=sys.stderr)
        thenclause = state_to_clause(a)

        json_resp['rule'] = {'id' : rule.id,
                             'ifClause' : ifclause,
                             'thenClause' : [thenclause],
                             'temporality' : 'event-state'}

    return json_resp


# return id:name dict of all devices
def all_devs(user):
    json_resp = {}
    for dev in m.Device.objects.filter(owner=user):
        json_resp[dev.id] = dev.name
    return json_resp

def user_devs(user):
    mydevs = m.Device.objects.filter(owner=user)
    pubdevs = m.Device.objects.filter(public=True)
    return mydevs.union(pubdevs)

# return id:name dict of all channels
def valid_chans(user,is_trigger):
    json_resp = {'chans' : []}
    chans = m.Channel.objects.filter(Q(capability__device__owner=user) | Q(capability__device__public=True)).distinct().order_by('name')
    devs = m.Device.objects.filter(Q(owner=user) | Q(public=True))
    chans = filter(lambda x : chan_has_valid_cap(x,devs,is_trigger),chans)
    for chan in chans:
        json_resp['chans'].append({'id' : chan.id, 'name' : chan.name, 'icon' : chan.icon})
    return json_resp

# combined call of all_devs and all_chans
# NOT IN USE
def fe_all_devs_and_chans(request):
    kwargs = request.POST
    user = m.User.objects.get(id=kwargs['userid'])
    json_resp = {}
    json_resp['devs'] = all_devs(user)
    json_resp['chans'] = all_chans(user)
    return JsonResponse(json_resp)

# FRONTEND VIEW
# let frontend get csrf cookie
@ensure_csrf_cookie
def fe_get_cookie(request):
    return JsonResponse({})

# FRONTEND VIEW
# gets all of a user's channels
def fe_all_chans(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    user = m.User.objects.get(id=kwargs['userid'])
    json_resp = valid_chans(user,kwargs['is_trigger'])
    return JsonResponse(json_resp)

def dev_has_valid_cap(dev,channel,is_trigger):
    poss_caps = dev.caps.all().intersection(m.Capability.objects.filter(channels=channel))
    if is_trigger:
        return any(map(lambda x : x.readable,poss_caps))
    else:
        return any(map(lambda x : x.writeable,poss_caps))

def chan_has_valid_cap(chan,devs,is_trigger):
    dev_caps = m.Capability.objects.none()
    for dev in devs:
        dev_caps = dev_caps.union(dev.caps.all())
    poss_caps = m.Capability.objects.filter(channels=chan).intersection(dev_caps)
    if is_trigger:
        return any(map(lambda x : x.readable,poss_caps))
    else:
        return any(map(lambda x : x.writeable,poss_caps))

# FRONTEND VIEW
# return id:name dict of all devices with a given channel
def fe_devs_with_chan(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    devs = m.Device.objects.filter(Q(owner_id=kwargs['userid']) | Q(public=True),
                                   chans__id=kwargs['channelid']).distinct().order_by('name')
    chan = m.Channel.objects.get(id=kwargs['channelid'])
    devs = filter(lambda x : dev_has_valid_cap(x,chan,kwargs['is_trigger']),devs)
    json_resp = {'devs' : []}
    for dev in devs:
        json_resp['devs'].append({'id' : dev.id,'name' : dev.name})
    return JsonResponse(json_resp)

# return id:name dict of all channels with a given device
# NOT IN USE
def fe_chans_with_dev(request,**kwargs):
    chans = m.Channel.objects.filter(capability__device__id=kwargs['deviceid'])
    json_resp = {}
    for chan in chans:
        json_resp[chan.id] = chan.name

    return JsonResponse(json_resp)

def rwfilter_caps(caps,is_trigger):
    if is_trigger:
        return filter((lambda x : x.readable),caps)
    else:
        return filter((lambda x : x.writeable),caps)


def map_labels(caps,is_trigger,is_event):
    if is_trigger:
        if is_event:
            return list(map((lambda x : (x.id,x.name,x.eventlabel)),caps))
        else:
            return list(map((lambda x : (x.id,x.name,x.statelabel)),caps))
    else:
        return list(map((lambda x : (x.id,x.name,x.commandlabel)),caps))

def filtermap_caps(caps,is_trigger,is_event):
    return map_labels(rwfilter_caps(caps,is_trigger),is_trigger,is_event)

# return id:name dict of all capabilities for a given dev/chan pair
# NOT IN USE
def fe_get_all_caps(request,**kwargs):
    caps = m.Capability.objects.filter(channels__id=kwargs['channelid'],device__id=kwargs['deviceid'])
    json_resp = {}
    for cap in caps:
        json_resp[cap.id] = cap.name
    return JsonResponse({'caps' : json_resp})

# FRONTEND VIEW
# return id:name dict of contextually valid capabilities for a given dev/chan pair
def fe_get_valid_caps(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    caps = m.Capability.objects.filter(channels__id=kwargs['channelid'],device__id=kwargs['deviceid']).order_by('name')

    json_resp = {'caps' : []}
    for id,name,label in filtermap_caps(caps,kwargs['is_trigger'],kwargs['is_event']):
        json_resp['caps'].append({'id' : id, 'name' : name, 'label' : label})
    return JsonResponse(json_resp)

# return id:(type,val constraints) dict of parameters for a given cap
def fe_get_params(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    cap = m.Capability.objects.get(id=kwargs['capid'])
    json_resp = {'params' : []}
    for param in m.Parameter.objects.filter(cap_id=kwargs['capid']).order_by('id'):
        if param.type == 'set':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : "set",
                                        'values' : [opt.value for opt in m.SetParamOpt.objects.filter(param_id=param.id)]})
        elif param.type == 'range':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'range',
                                        'values' : [param.rangeparam.min,param.rangeparam.max,param.rangeparam.interval]})
        elif param.type == 'bin':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'bin',
                                        'values' : [param.binparam.tval,param.binparam.fval]})
        elif param.type == 'input':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'input',
                                        'values' : [param.inputparam.inputtype]})
        elif param.type == 'time':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'time',
                                        'values' : [param.timeparam.mode]})
        elif param.type == 'duration':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'duration',
                                        'values' : [param.durationparam.maxhours,param.durationparam.maxmins,param.durationparam.maxsecs]})
        elif param.type == 'color':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'color',
                                        'values' : [param.colorparam.mode]})
        elif param.type == 'meta':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'meta',
                                        'values' : [param.metaparam.is_event]})
    return JsonResponse(json_resp)


###############################################################################
## [RC] RULE CREATION
###############################################################################

# get the state of a cap/dev pair, or create one if none exists
def get_or_make_state(cap,dev,is_action=False):
    try:
        state = m.State.objects.get(cap=cap,dev=dev,action=is_action)
    except m.State.DoesNotExist:
        state = m.State(cap=cap,dev=dev,action=is_action)
        state.save()

    return state


def update_pv(state,par_id,val):
    try:
        pv = m.ParVal.objects.get(state=state,par_id=par_id)
        pv.val = val
        pv.save()
    except m.ParVal.DoesNotExist:
        pv = m.ParVal(state=state,par_id=par_id,val=val)
        pv.save()

# create (OR EDIT) Event State Rule
def fe_create_esrule(request,forcecreate=False):
    kwargs = json.loads(request.body.decode('utf-8'))
    return JsonResponse(fe_create_esrule_core(kwargs, forcecreate))
    
def fe_create_esrule_core(kwargs, forcecreate:bool):
    # rule, mode("create"?), [userid, taskid, version](create), ruleid(modify)
    ruleargs = kwargs['rule']
    ifclause = ruleargs['ifClause']
    
    event = ifclause[0]

    e_trig = clause_to_trigger(event)

    action = ruleargs['thenClause'].pop()
    a_state = m.State(cap=m.Capability.objects.get(id=action['capability']['id']),
                      dev=m.Device.objects.get(id=action['device']['id']),
                      chan=m.Channel.objects.get(id=action['channel']['id']),
                      action=True,
                      text=action['text'])
    a_state.save()

    if kwargs['mode'] == "create" or forcecreate==True:
        rule = m.ESRule(owner=m.User.objects.get(id=kwargs['userid']),
                        type='es',
                        task = kwargs['taskid'],
                        version=kwargs['version'],
                        Etrigger=e_trig,
                        action=a_state)
        rule.save()
    else: #edit existing rule
        try:
            rule = m.ESRule.objects.get(id=kwargs['ruleid'])
        except m.ESRule.DoesNotExist:
            return fe_create_esrule_core(kwargs,forcecreate=True)

        rule.Etrigger=e_trig
        rule.action=a_state
        rule.save()
        for st in rule.Striggers.all():
            rule.Striggers.remove(st)

    try:
        for state in ifclause[1:]:
            s_trig = clause_to_trigger(state)
            rule.Striggers.add(s_trig)
    except IndexError:
        pass

    return fe_all_rules_core(kwargs)


def fe_delete_rule(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    return JsonResponse(fe_delete_rule_core(kwargs))

def fe_delete_rule_core(kwargs):
    # ruleid, userid, taskid?, version?
    if "taskid" not in kwargs:
        kwargs["taskid"] = -1
    
    try:
        rule = m.Rule.objects.get(id=kwargs['ruleid'])
    except m.Rule.DoesNotExist:
        return fe_all_rules_core(kwargs)

    if rule.owner.id == kwargs['userid']:
        if rule.type == 'es':
            rule.esrule.Etrigger.delete()
            for st in rule.esrule.Striggers.all():
                st.delete()
            rule.esrule.action.delete()
        rule.delete()
    
    return fe_all_rules_core(kwargs)


## not functional
def fe_create_ssrule(request,**kwargs):
    priority = kwargs['priority']
    action = m.State.objects.get(id=kwargs['actionid'])
    rule = m.SSRule(action=action,priority=priority)
    rule.save()

    for val in kwargs['triggerids']:
        rule.triggers.add(m.State.objects.get(id=val))

    return JsonResponse({'ssruleid' : rule.id})

def fe_create_rule(request,**kwargs):
    if kwargs['temp'] == 'es':
        return fe_create_esrule(request,kwargs)
    else:
        return fe_create_ssrule(request,kwargs)

###############################################################################
## [SPC] SAFETY PROPERTY CREATION
###############################################################################

def time_to_int(time):
    return time['seconds'] + time['minutes']*60 + time['hours']*3600

def int_to_time(secs):
    time = {}
    time['hours'] = secs // 3600
    time['minutes'] = (secs // 60) % 60
    time['seconds'] = secs % 60
    return time


def clause_to_trigger(clause):
    t = m.Trigger(chan=m.Channel.objects.get(id=clause['channel']['id']),
                  dev=m.Device.objects.get(id=clause['device']['id']),
                  cap=m.Capability.objects.get(id=clause['capability']['id']),
                  pos=clause['id'],
                  text=clause['text'])
    t.save()

    try:
        pars = clause['parameters']
        vals = clause['parameterVals']
        for par,val in zip(pars,vals):
            cond = m.Condition(par=m.Parameter.objects.get(id=par['id']),
                               val=val['value'],
                               comp=val['comparator'],
                               trigger=t)
            cond.save()
    except KeyError:
        pass

    return t


def trigger_to_clause(trigger,is_event):
    c = {'channel' : {'id' : trigger.chan.id,
                      'name' : trigger.chan.name,
                      'icon' : trigger.chan.icon},
         'device' : {'id' : trigger.dev.id,
                     'name' : trigger.dev.name},
         'capability' : {'id' : trigger.cap.id,
                         'name' : trigger.cap.name,
                         'label' : (trigger.cap.eventlabel if is_event else trigger.cap.statelabel)},
         'text' : trigger.text,
         'id' : trigger.pos}
    conds = m.Condition.objects.filter(trigger=trigger).order_by('id')
    if conds != []:
        c['parameters'] = []
        c['parameterVals'] = []

        for cond in conds:
            c['parameters'].append({'id' : cond.par.id,
                                    'name' : cond.par.name,
                                    'type' : cond.par.type})
            c['parameterVals'].append({'comparator' : cond.comp,
                                       'value' : cond.val})
    return c

def state_to_clause(state):
    c = {'channel' : {'id' : state.chan.id,
                      'name' : state.chan.name,
                      'icon' : state.chan.icon},
         'device' : {'id' : state.dev.id,
                     'name' : state.dev.name},
         'capability' : {'id' : state.cap.id,
                         'name' : state.cap.name,
                         'label' : state.cap.commandlabel},
         'text' : state.text}
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
                par_c['value_list_in_statement'] = [f_val.group('value'), t_val.group('value')]
            else:
                par_c['value_list_in_statement'] = par_c['value_list'] = [bin_par.fval, bin_par.tval]
        elif par.type == 'range':
            par_c['value_list'] = []
        elif par.type == 'set':
            par_c['value_list'] = [opt.value for opt in m.SetParamOpt.objects.filter(param_id=par.id)]
        else:
            raise Exception('var type %s not supported' % par.type)

        par_dict[par.name] = par_c

    template_text = cap.commandlabel.replace('(', '\(')
    template_text = template_text.replace(')', '\)')
    template_text = re.sub(r'\{DEVICE\}', state.dev.name, template_text)
    template_text = re.sub(r'\{(\w+)/(T|F)\|[\w &\-]+\}\{\1/(T|F)\|[\w &\-]+\}', r'(?P<\1>[\w &\-]+)', template_text)
    template_text = re.sub(r'\{(\w+)\}', r'(?P<\1>[\w &\-]+)', template_text)
    re_mat = re.match(template_text, state.text)

    for par, par_c in par_dict.items():
        par_dict[par_c['name']]['value'] = re_mat.group(par_c['name'])

    c['parameters'] = [{'type': par_c['type'], 'name': par_c['name'], 'id': par_c['id']}
                       for par, par_c in sorted(par_dict.items())]
    c['parameterVals'] = list()
    for par, par_c in sorted(par_dict.items()):
        if par_c['type'] == 'bin':
            value = par_c['value_list'][par_c['value_list_in_statement'].index(par_c['value'])]
        else:
            value = par_c['value']
        c['parameterVals'].append({'comparator': '=', 'value': value})

    return c


def display_trigger(trigger):
    return {'channel' : {'icon' : trigger.chan.icon}, 'text' : trigger.text}
