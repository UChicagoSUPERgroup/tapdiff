import itertools as it
from sympy.logic import simplify_logic
from .NodeToDevStates import getDevType, getIntVars

################################################
########## For state-based properties ##########
################################################

class StateSpInfo:
    '''Has: unreach_set_1, unreach_set_2, shared_unreach_set, unshared_unreach_set1, unshared_unreach_set2.'''
    def __init__(self, unreach_set_1, unreach_set_2, shared_unreach_set, unshared_unreach_set1, unshared_unreach_set2):
        self.unreach_set_1 = unreach_set_1
        self.unreach_set_2 = unreach_set_2
        self.shared_unreach_set = shared_unreach_set
        self.unshared_unreach_set1 = unshared_unreach_set1
        self.unshared_unreach_set2 = unshared_unreach_set2


def minStates(states_set, action_index=-1):
    '''Given a set of states (e.g. shared unreachable states between the 2 prgms), get the minimal expression in dnf as a str.
    Note that order in each tuple is kept w/ index 0.
    Example of states_set: {(0, 1, 1), (1, 1, 1), (0, 0, 1), (1, 1, 0), (1, 0, 1)}
    NOTE: we will use this for the states for edge-based sps too, but ignoring the actual event which is on action_index'''
    expr_to_simplify_lst = []
    for state in states_set:
        # expr_to_simplify_lst.append('(' + (' & '.join([('~x' if state[i]==0 else 'x')+str(i) for i in range(len(state))])) + ')')
        expr_to_simplify_lst.append('(' + (' & '.join([('y' if i == action_index else ('~x' if state[i]==0 else 'x'))+str(i) for i in range(len(state))])) + ')')
    expr_to_simplify = ' | '.join(expr_to_simplify_lst)
    simplified_expr = str(simplify_logic(expr_to_simplify, 'dnf'))
    return simplified_expr # ex. 'x2 | (x0 & x1)'


def minStatesToSps(never_groups, ap_list):
    ''' Given a string of never_groups in the form of (bool expr) | (bool expr), and an ap_list, 
    figure out what the never_groups refer to in terms of caps.
    E.g. never_groups = (x0 & x1) | (x0 & ~x2), ap_list says that x0 is door lock and x1 is day/nighttime and etc.,
    convert never_groups into a set of never_sps in terms of these aps.
    Note that ap_list elts are like 'cap=val' where we only want the cap.'''
    never_sps = set()
    never_groups_lst = never_groups.split(' | ')
    for group in never_groups_lst:
        group_lst = group.strip('(').strip(')').split(' & ')
        sp = []
        for x in group_lst:
            if x.startswith('y'):
                continue
            val = 'false' if x.startswith('~') else 'true'
            ap_i = x.strip('~').strip('x')
            ap = ap_list[int(ap_i)].split('=')[0]
            sp.append(ap+'='+val)
        never_sps.add(frozenset(sorted(sp)))
    return never_sps


def stateSpInAlwaysForm(simp_sps, template_dict):
    ''' Decide if each sp has an intuitive "always" alternative with template_dict.
    Convert all sps to frontend/backend-compatible dict with their text, caps, type/code.
    TODO: not sure about range and sets'''
    all_sps = []
    for sp in simp_sps: # frozenset
        sp_qualifier = '' # always vs. never
        sp_type = 0 # 1,2,3
        sp_sorted = []
        sp_text = ''
        if len(sp)==1: # state X should never be active
            # if bool, convert to "always"; if set, stay as "never"
            [param, val] = list(sp)[0].split('=')
            if getDevType(param, template_dict)[0]=='bool':
                # we're gonna assume that this can never be external...
                assert(getDevType(param, template_dict)[1]==0), 'External state should never be active???: %s' % (sp)
                sp = param+('=true' if val=='false' else '=false')
                sp_qualifier = 'always'
            else:
                sp_qualifier = 'never'
            sp_type = 2
            sp_sorted = [sp]
            sp_text = '%s should %s be active' % (sp, sp_qualifier)
        else:
            int_vars = getIntVars(sp, template_dict)
            num_int_vars = len(int_vars)
            # if there is only one internal variable (X) in "XYZ never together", convert it to "state !X should always be active while YZ"
            assert(num_int_vars > 0), "There's no internal vars (all external vars)??? %s " % (str(sp))
            if num_int_vars==1:
                other_vars = sorted([v for v in sp if v not in int_vars])
                [int_var_param, val] = int_vars[0].split('=')
                new_int_var = int_var_param+('=true' if val=='false' else '=false')
                sp_sorted = [new_int_var] + other_vars
                sp_qualifier = 'always'
                sp_type = 2
                sp_text = '%s should always be active while %s' % (new_int_var, ' and '.join(other_vars))
            else:
                sp_qualifier = 'never'
                sp_type = 1
                sp_sorted = sorted(sp)
                sp_text = 'it should never be the case that %s are together' % (' and '.join(sp_sorted))
        assert(sp_qualifier != '' and sp_type in [1,2,3] and sp_sorted != [] and sp_text != ''), "oh no: %s %d %s %s" % (sp_qualifier, sp_type, str(sp_sorted), sp_text)
        all_sps.append({'type': sp_type, 'text': sp_text, 'caps': sp_sorted, 'always': sp_qualifier == 'always'})
    return all_sps
# ex. [{'type': 1, 'always': False, 'text': 'hue_lights.power_onoff_setting=false and living_room_window.openclose_curtains_position=false should never occur together', 'caps': ['hue_lights.power_onoff_setting=false', 'living_room_window.openclose_curtains_position=false']}, {'type': 1, 'always': False, 'text': 'clock.is_it_daytime_time=false and hue_lights.power_onoff_setting=false should never occur together', 'caps': ['clock.is_it_daytime_time=false', 'hue_lights.power_onoff_setting=false']}]
