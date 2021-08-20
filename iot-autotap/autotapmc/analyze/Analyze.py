"""
Copyright 2017-2019 Lefan Zhang

This file is part of AutoTap.

AutoTap is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AutoTap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AutoTap.  If not, see <https://www.gnu.org/licenses/>.
"""


from .Build import tapFormat, generateCriticalValue, generateTimeExp, getChannelList, ltlFormat, generateChannelDict, textToformula
from .Fix import _fixPreProcessing, _getAction, _getLTLReq
from autotapmc.analyze.Formula import checkEventAgainstTrigger
import autotapmc.buchi.Buchi as Buchi


def evaluateRules(tap_list, ltl):
    pass


def checkTapListBehavior(tap_list, system, src_field, action):
    result = list()
    for tap in tap_list:
        if checkEventAgainstTrigger(action, tap.trigger) and system.tapConditionSatisfied(tap, src_field):
            # TODO: what does timing do in this case
            result.append(tap.action)
    return result


def relToCrit(s, crit_vs): # str, dict
    # ex. crit_vs = {'brightness_sensor.illuminance_illuminance': [100]}
    if '=' not in s:
        return s
    [cap, v] = s.split('=')
    if cap not in crit_vs:
        return s

    try:
        vv = int(v)
        if vv in crit_vs[cap]:
            return s
        if len(crit_vs[cap])==1:
            crit_v = crit_vs[cap][0]
            new_t = '<'+str(crit_v) if vv < crit_v else '>'+str(crit_v)
            return cap+new_t
        else: # TODO: when there are multiple crit vals for the same cap...
            return s
    except ValueError:
        return s


def compareRules(tap_list1, tap_list2, template_dict, init_state_dict=None):
    """
    To show the differences between tap_list1 and tap_list2
    :param tap_list1:
    :param tap_list2:
    :param ltl:
    :param template_dict:
    :return:
    """
    ltl_formula = '!(0)'

    crit_value_dict = generateCriticalValue(ltl_formula, tap_list1 + tap_list2, with_timing_ops=False)
    exp_t_list, record_exp_list = generateTimeExp(ltl_formula, tap_list1 + tap_list2)
    channel_name_list, cap_name_list, tap_list = getChannelList(ltl_formula, tap_list1 + tap_list2, False)

    tap_list1 = tapFormat(tap_list1, crit_value_dict, template_dict)
    tap_list2 = tapFormat(tap_list2, crit_value_dict, template_dict)

    new_ltl = ltlFormat(ltl_formula)
    # stage 4: generate system
    if init_state_dict:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           init_state_dict, cap_name_list, template_dict)
    else:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           {}, cap_name_list, template_dict)
    system = _fixPreProcessing(
        channel_dict=channel_dict,
        tap_dict={},
        template_numeric_dict=crit_value_dict,
        timing_exp_list=exp_t_list
    )

    ts = system.transition_system
    buchi_ts = Buchi.tsToGenBuchi(ts, record_exp_list)
    field_list = [state.field for state in ts.state_list]

    result = list()
    for edge in buchi_ts.edge_list:
        try:
            src_index_ts = edge.src
            dst_index_ts = edge.dst
            if ts.num_state == src_index_ts:
                # this is the initial node, skip
                continue
            src_field = field_list[src_index_ts]
            action = _getAction(ts, src_index_ts, dst_index_ts)

            beh1 = checkTapListBehavior(tap_list1, system, src_field, action)
            beh2 = checkTapListBehavior(tap_list2, system, src_field, action)

            beh1 = sorted(list(set(beh1)))
            beh2 = sorted(list(set(beh2)))

            # condition = [ap for ap in system.getApList(src_field)
            #              if '@' not in ap and 'trigger' not in ap]
            # condition = condition + ['!' + ap for ap in system.getAllAp()
            #                          if '@' not in ap and 'trigger' not in ap and
            #                          ap not in condition]

            condition = system.getCondensedApList(src_field, template_dict)

            if beh1 != beh2:
                result.append((action, condition, (beh1, beh2)))

        except IndexError:
            # if this happen, this means that the system has already been in wrong state from the initial state
            raise Exception(
                'The property is violated in the initial state, please try a different initial state')

    new_result = list()
    for action, condition, beh_tup in result:
        new_action = relToCrit(textToformula(action), crit_value_dict)
        new_condition = [relToCrit(cond, crit_value_dict) for cond in condition]
        new_beh_0 = [relToCrit(textToformula(beh), crit_value_dict) for beh in beh_tup[0]]
        new_beh_1 = [relToCrit(textToformula(beh), crit_value_dict) for beh in beh_tup[1]]
        new_result.append((
            new_action,
            new_condition,
            (new_beh_0, new_beh_1)
        ))
    return new_result


def mergeRules(rule_list):
    """
    give a set of tap rules, based on their action/triggerring event, merge their state constraints
    to generate a minimum set of rules
    :param rule_list: the list of Rule objects
    :return: the merged list of Rule objects
    """
    pass
