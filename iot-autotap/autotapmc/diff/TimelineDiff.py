from autotapmc.analyze.Analyze import checkTapListBehavior, relToCrit
from autotapmc.analyze.Build import tapFormat, generateCriticalValue, generateTimeExp, getChannelList, \
     ltlFormat, generateChannelDict, textToformula, changeBooleanToInt, getSetOptions
from autotapmc.analyze.Fix import _fixPreProcessing, _getAction, _getLTLReq
import autotapmc.buchi.Buchi as Buchi
from autotapmc.model.IoTSystem import generateIoTSystem
from autotapmc.model.IoTSystemForDiff import generateFastIoTSystem

import json


def compareRulesOrig(tap_list1, tap_list2, template_dict, init_state_dict=None):
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
    set_value_dict = getSetOptions(template_dict)
    exp_t_list, record_exp_list = generateTimeExp(ltl_formula, tap_list1 + tap_list2)
    channel_name_list, cap_name_list, tap_list = getChannelList(ltl_formula, tap_list1 + tap_list2, False)

    # stage 4: generate system
    if init_state_dict:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           init_state_dict, cap_name_list, template_dict)
    else:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           {}, cap_name_list, template_dict)
    # system = _fixPreProcessing(
    #     channel_dict=channel_dict,
    #     tap_dict={},
    #     template_numeric_dict=crit_value_dict,
    #     timing_exp_list=exp_t_list
    # )
    system = generateFastIoTSystem('TempSystem', channel_dict, {}, crit_value_dict, set_value_dict)

    tap_dict_1 = {str(ii): tap for ii, tap in zip(range(len(tap_list1)), tap_list1)}
    tap_dict_2 = {str(ii): tap for ii, tap in zip(range(len(tap_list2)), tap_list2)}

    # system_1 = generateIoTSystem('TempSystem', channel_dict, tap_dict_1, exp_t_list)
    system_1 = generateFastIoTSystem('TempSystem', channel_dict, tap_dict_1, crit_value_dict, set_value_dict)
    system_1._restoreFromStateVector(system_1.transition_system.getField(0))

    # system_2 = generateIoTSystem('TempSystem', channel_dict, tap_dict_2, exp_t_list)
    system_2 = generateFastIoTSystem('TempSystem', channel_dict, tap_dict_2, crit_value_dict, set_value_dict)
    system_2._restoreFromStateVector(system_2.transition_system.getField(0))
    # system_1 = _fixPreProcessing(
    #     channel_dict=channel_dict,
    #     tap_dict=tap_dict_1,
    #     template_numeric_dict=crit_value_dict,
    #     timing_exp_list=exp_t_list
    # )
    # system_2 = _fixPreProcessing(
    #     channel_dict=channel_dict,
    #     tap_dict=tap_dict_2,
    #     template_numeric_dict=crit_value_dict,
    #     timing_exp_list=exp_t_list
    # )
    reach_set_1 = {system_1.getPureStateList(state.field) 
                   for state in system_1.transition_system.state_list 
                   if not system_1.isTriggeredState(state.field)}
    reach_set_2 = {system_2.getPureStateList(state.field) 
                   for state in system_2.transition_system.state_list 
                   if not system_2.isTriggeredState(state.field)}
    intersec_nodes = reach_set_1.intersection(reach_set_2)
    
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
            if tuple(changeBooleanToInt(src_field)) not in intersec_nodes:
                # this is not reachable for every case
                continue
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

            if beh1 != beh2:
                condition = system.getCondensedApList(src_field, template_dict)
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


def compareRules(tap_list1, tap_list2, template_dict, task=None, version_1=None, version_2=None):
    # get init states
    if task is not None and version_1 is not None and version_2 is not None:
        json_init_file = '../diff_init/init_%s.json' % str(task)
        with open(json_init_file, 'r') as fp:
            init_state_dict = json.load(fp)
            # The init state should be the same for every version
            init_state_dict = init_state_dict['0'] #str(version_1)]
    else:
        init_state_dict = None
    return compareRulesOrig(tap_list1, tap_list2, template_dict, init_state_dict)
