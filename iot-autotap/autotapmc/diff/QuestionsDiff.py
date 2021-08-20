from autotapmc.analyze.Build import generateCriticalValue, generateTimeExp, getChannelList, \
    generateChannelDict, tapFormat, ltlFormat, textToformula, changeBooleanToInt, getSetOptions
from autotapmc.analyze.Analyze import checkTapListBehavior, relToCrit
from autotapmc.analyze.Fix import _fixPreProcessing, _getAction
from autotapmc.model.IoTSystemForDiff import generateFastIoTSystem
import autotapmc.buchi.Buchi as Buchi
import json


def compareMultipleVerRulesOrig(ver_taps_list, ver_list, template_dict, init_state_dict=None):
    ltl_formula = '!(0)'
    taps_all_list = []
    for tap_list in ver_taps_list:
        taps_all_list += tap_list

    crit_value_dict = generateCriticalValue(ltl_formula, taps_all_list, with_timing_ops=False)
    set_value_dict = getSetOptions(template_dict)

    exp_t_list, record_exp_list = generateTimeExp(ltl_formula, taps_all_list)
    channel_name_list, cap_name_list, tap_list = getChannelList(
        ltl_formula, taps_all_list, False)

    # for ii in range(len(ver_taps_list)):
    #     tap_list = ver_taps_list[ii]
    #     ver_taps_list[ii] = tapFormat(tap_list, crit_value_dict, template_dict)

    new_ltl = ltlFormat(ltl_formula)
    # stage 4: generate system
    if init_state_dict:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           init_state_dict, cap_name_list, template_dict)
    else:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           {}, cap_name_list, template_dict)
    
    system_list = []
    for tap_list in ver_taps_list:
        tap_dict = {str(ii): tap for ii, tap in zip(range(len(tap_list)), tap_list)}
        system = generateFastIoTSystem("TempSystem", channel_dict, tap_dict, critical_value_dict=crit_value_dict, set_value_dict=set_value_dict)
        system._restoreFromStateVector(system.transition_system.getField(0))
        system_list.append(system)


    system_empty = generateFastIoTSystem("TempSystem", channel_dict, {}, critical_value_dict=crit_value_dict, set_value_dict=set_value_dict)
    system_empty._restoreFromStateVector(system_empty.transition_system.getField(0))

    reachability_vers_list = list()
    for system in system_list:
        ts = system.transition_system
        reach_set = {system.getPureStateList(state.field)
                     for state in ts.state_list
                     if not system.isTriggeredState(state.field)}
        reachability_vers_list.append(reach_set)

    intersec_nodes = reachability_vers_list[0].intersection(
        *reachability_vers_list[1:])
    ts = system_empty.transition_system
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

            beh_list = [sorted(list(set(checkTapListBehavior(tap_list, system_empty, src_field, action))))
                        for tap_list in ver_taps_list]

            # condition = [ap for ap in system.getApList(src_field)
            #              if '@' not in ap and 'trigger' not in ap]
            # condition = condition + ['!' + ap for ap in system.getAllAp()
            #                          if '@' not in ap and 'trigger' not in ap and
            #                          ap not in condition]

            condition = system_empty.getCondensedApList(
                src_field, template_dict)

            if not all([beh == beh_list[0] for beh in beh_list]):
                result.append((action, condition, beh_list))

        except IndexError:
            # if this happen, this means that the system has already been in wrong state from the initial state
            raise Exception(
                'The property is violated in the initial state, please try a different initial state')

    new_result = list()
    for action, condition, beh_list in result:
        new_action = relToCrit(textToformula(action), crit_value_dict)
        new_condition = [relToCrit(cond, crit_value_dict)
                         for cond in condition]
        new_beh_list = [
            [relToCrit(textToformula(beh), crit_value_dict) for beh in beh_l]
            for beh_l in beh_list
        ]
        new_result.append((
            new_action,
            new_condition,
            new_beh_list
        ))
    return new_result


def compareMultipleVerRules(ver_rules_list, ver_list, template_dict, task=None):
    if task is not None and all([ver is not None for ver in ver_list]):
        json_init_file = '../diff_init/init_%s.json' % str(task)
        with open(json_init_file, 'r') as fp:
            init_state_dict = json.load(fp)
            init_state_dict = init_state_dict['0']
    else:
        init_state_dict = None
    return compareMultipleVerRulesOrig(ver_rules_list, ver_list, template_dict, init_state_dict)