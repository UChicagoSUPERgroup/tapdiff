from sympy.logic import simplify_logic, SOPform
from sympy import symbols
from .NodeToDevStates import getParts

import itertools

################################################
########## For edge-based properties ##########
################################################

# This is not great code :'(
COMPS_DICT = {
    '>': 'GREATERTHAN',
    '<': 'LESSTHAN',
    '>=': 'GREATEREQUAL',
    '<=': 'LESSEQUAL'
}


def getCap(cap_val):
    ''' Given a str of "dev.cap=val", return it as "devQQQcapPPPval".
    If val==false, flip it to true and flip cap to ~cap instead. '''
    if '>' in cap_val or '<' in cap_val or '=' not in cap_val:
        (cap, comp, val) = getParts(cap_val)
        new_comp = COMPS_DICT[comp]  # text of the comp, ex. 'LESSTHAN'
        (dev, new_cap) = cap.split('.')
        # TODO: this does not let <> be grouped
        return dev+'QQQ'+new_cap+'PPP'+new_comp+'HHH'+val.replace('.', '_')
    (cap, val) = cap_val.split('=')
    if val == 'false':
        cap = '~'+cap
        val = 'true'
    (dev, new_cap) = cap.split('.')
    # because no other divider symbols would work XD
    return dev+'QQQ'+new_cap+'PPP'+val


def undoWeirdDivider(s):
    if 'HHH' in s:
        new_s = '.'.join(s.split('QQQ')).strip().strip('(').strip(')')
        (cap, rest) = new_s.split('PPP')
        (comp, val) = rest.split('HHH')
        new_comp = [x for x in COMPS_DICT if COMPS_DICT[x]
                    == comp]  # fake bi-directional dict lol
        assert(len(new_comp) ==
               1), 'got more than 1 comp in undoWeirdDivider(): %s' % new_comp
        new_comp = new_comp[0]
        return cap+new_comp+val
    new_s = '.'.join(s.split('QQQ')).strip().strip(
        '(').strip(')')  # recover the cap I think
    if new_s[0] == '~':
        new_s = new_s[1:]
        new_s = new_s.split('PPP')[0] + '=false'
    else:
        new_s = '='.join(new_s.split('PPP'))
    return new_s


def get_all_symbols(s):
    s = s.replace('(', '')
    s = s.replace(')', '')
    s = s.replace('~', '')
    s = s.replace('&', ' ')
    s = s.replace('|', ' ')

    symb_list = [ss for ss in s.split(' ') if ss]
    return set(symb_list)


def evaluate_exp(value_dict, exp):
    # exp should be a&b&c...
    if exp.startswith('(') and exp.endswith(')'):
        exp = exp[1:-1]
        exp = exp.strip()
    exp = exp.split('&')
    for e in exp:
        neg = False
        e = e.strip()
        if e.startswith('~'):
            neg = True
            e = e[1:]
            e = e.strip()
        if (neg and value_dict[e]) or (not neg and not value_dict[e]):
            return False
    return True


def simplify_with_dc(s, dcs):
    ''' From Lefan: use dontcares to ignore unr nodes for event-never sps'''
    symb_list = get_all_symbols(s)
    for dc in dcs:
        symb_list = symb_list.union(get_all_symbols(dc))
    symb_list = sorted(list(symb_list))
    symbs = [symbols(symb) for symb in symb_list]
    minterms = []
    dontcares = []

    for term in itertools.product([False, True], repeat=len(symb_list)):
        flag = 0  # 0: none, 1: minterm, 2: don't care
        term = list(term)
        value_dict = {k: v for k, v in zip(symb_list, term)}
        for s_i in s.split('|'):
            if evaluate_exp(value_dict, s_i):
                flag = 1
                break
        for dc_i in dcs:
            if evaluate_exp(value_dict, dc_i):
                flag = 2
                break
        if flag == 1:
            minterms.append(term)
        elif flag == 2:
            dontcares.append(term)
        else:
            pass
    
    result = SOPform(symbs, minterms, dontcares)
    return str(result).split('|')


def groupSps(unsh_sps, dontcares_arg=set()):
    # ex. dontcares_arg = {frozenset({'clock.is_it_daytime_time=false', 'hue_lights.power_onoff_setting=false'})}

    dontcares = set() # ex. ['~clockQQQis_it_daytime_timePPPtrue&~hue_lightsQQQpower_onoff_settingPPPtrue']
    for never_together_sp in dontcares_arg:
        dontcares.add('&'.join([getCap(cap_val) for cap_val in never_together_sp]))
    
    unsh_sps_res = []

    d = {}
    for sp in unsh_sps:
        key = str(sp['type']) + '|' + str(sp['always']) + '|' + sp['caps'][0]
        if key not in d:
            d[key] = []
        d[key].append('('+'&'.join([getCap(cap_val)
                                    for cap_val in sp['caps'][1:]])+')')

    new_d = {}
    for k in d:
        if d[k]==['()']:
            new_d[k] = d[k]
        else:
            s = '|'.join(d[k])
            new_d[k] = simplify_with_dc(s, dontcares)
        # if s != '()':
        #     simplified = str(simplify_logic(s, "dnf")) # dnf is important!!! SOP form
        #     new_d[k] = simplified.split('|')  # disjunction
        # else:
        #     new_d[k] = []
    for k in new_d:
        if new_d[k] != []:
            (t, a, fa) = k.split('|')
            a = True if a.lower() == 'true' else False
            for v in new_d[k]:
                states = v.strip('(').strip(')').strip().split('&')
                if states==['']: 
                    states = []
                else:
                    states = sorted([undoWeirdDivider(vv) for vv in states])
                verb = " happen " if int(t) == 3 else " be active "
                conds = ('while '+' and '.join(states)) if states!=[] else ''
                caps = [fa]+states
                if len(set([c.split('=')[0] for c in caps])) == len([c.split('=')[0] for c in caps]):
                    # all cap devs are unique, i.e. the sp isn't something like "camera will never turn on while it's off"
                    # in buchi this is a missing edge between {off} -> {on} while the state of camera is off for both, which
                    # makes 0 sense, so...
                    unsh_sps_res.append({'type': int(t), 'always': a,
                                     'text': fa+' should '+('always' if a == True else 'never')+verb+conds,
                                     'caps': caps})
        else: # type 2 singleton sp
            assert(t=='2'), 'wait why not type 2 singleton?: %s' % (str(sp))
            (t, a, fa) = k.split('|')
            a = True if a.lower() == 'true' else False
            unsh_sps_res.append({'type': int(t), 'always': a,
                                     'text': fa+' should '+('always' if a == True else 'never')+' be active',
                                     'caps': fa})
    return unsh_sps_res


def minEdgeSps(edge_sps, unreach_set, system):
    new_edge_sps = []
    for edge_sp in edge_sps:
        sp_dict = dict()
        sp_dict['type'] = 3
        sp_dict['always'] = False
        sp_dict['caps'] = [edge_sp[0]] + list(edge_sp[1])
        new_edge_sps.append(sp_dict)
    
    new_unreach_set = set()
    for us in unreach_set:
        new_us = []
        for var_name, val in zip(system.var_list, us):
            new_us.append(var_name + '=' + ('true' if val == 1 else 'false'))
        new_unreach_set.add(frozenset(new_us))

    result_edge_sps = groupSps(new_edge_sps, new_unreach_set)
    new_result_edge_sps = set()
    for res in result_edge_sps:
        new_result_edge_sps.add((res['caps'][0], frozenset(res['caps'][1:])))
    return new_result_edge_sps


def getFinalEdgeSps(edge_sps):
    ''' Return the found edge_sps in the correct format. 
    (We will treat all sps coming from missing edges as "X should NEVER happen while Y.")'''
    unsh_sps = []
    for (action, sharedStates) in edge_sps:
        sharedStates_sorted = sorted(sharedStates)
        unsh_sps.append({'type': 3, 'always': False,
                         'text': action+' should never happen while '+' and '.join(sharedStates_sorted),
                         'caps': [action]+sharedStates_sorted})
    return unsh_sps