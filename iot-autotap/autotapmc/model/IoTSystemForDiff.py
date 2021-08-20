from autotapmc.model.IoTSystem import IoTSystem, MetaIoTSystem
import autotapmc.ts.TransitionSystem as TransitionSystem
from autotapmc.analyze.Formula import checkEventAgainstTrigger, checkValueAgainstCondition, splitSimpleFormula


class FastIoTSystem(IoTSystem):
    """
    Only work for boolean variables
    TODO: support other types of variables
    Only work for ESERules
    Not working for timing
    """
    def __init__(self, critical_value_dict={}, set_value_dict={}):
        self.var_list = self._getVarList()
        self.var_index_dict = {var_name: index for var_name, index in zip(self.var_list, range(len(self.var_list)))}
        self.var_type_list = ['set' if var in set_value_dict else ('range' if var in critical_value_dict else 'bool')
                              for var in self.var_list]
        self.var_type_dict = dict(zip(self.var_list, self.var_type_list))

        # initialize critical value and set value list
        self.set_value_dict = set_value_dict
        self.crit_value_dict = {k: [float(v) for v in l] for k, l in critical_value_dict.items()}
        self.enhanced_crit_value_dict = dict()
        for var_name, crit_list in critical_value_dict.items():
            left_list = crit_list[:-1]
            right_list = crit_list[1:]
            mid_list = [(v1 + v2) / 2 for v1, v2 in zip(left_list, right_list)]
            self.enhanced_crit_value_dict[var_name] = sorted(crit_list + mid_list)
            self.enhanced_crit_value_dict[var_name] = [min(self.enhanced_crit_value_dict[var_name]) - 1] + \
                                                      self.enhanced_crit_value_dict[var_name] + \
                                                      [max(self.enhanced_crit_value_dict[var_name]) + 1]

        self.tap_name_list = sorted(self.tap_dict.keys())
        self.tap_trigger_list = [tap.trigger for _, tap in sorted(self.tap_dict.items())]
        self.tap_action_list = [tap.action for _, tap in sorted(self.tap_dict.items())]
        self.tap_condition_list = list()
        for _, tap in sorted(self.tap_dict.items()):
            condition_index_list = list()
            condition_target_list = list()
            for cond in tap.condition:
                neg = False
                if cond.startswith('!'):
                    neg = True
                    cond = cond[1:]
                # split var_name with value_str
                if '=' in cond:
                    var_name, value_str = cond.split('=')
                    comp = '='
                elif '<' in cond:
                    var_name, value_str = cond.split('<')
                    comp = '<'
                else:
                    var_name, value_str = cond.split('>')
                    comp = '>'

                target_val_set = set()
                if value_str in {'true', 'false'}:
                    # boolean variable
                    target_val = value_str == 'true'
                    target_val = target_val != neg
                    target_val_set.add(target_val)
                elif value_str.replace('_', '.').replace('.', '').isnumeric():
                    # range variable
                    value = float(value_str.replace('_', '.'))
                    if comp == '=' and not neg:
                        target_val_set = {v for v in self.enhanced_crit_value_dict[var_name] if v == value}
                    elif comp == '=' and neg:
                        target_val_set = {v for v in self.enhanced_crit_value_dict[var_name] if v != value}
                    elif comp == '<' and not neg:
                        target_val_set = {v for v in self.enhanced_crit_value_dict[var_name] if v < value}
                    elif comp == '<' and neg:
                        target_val_set = {v for v in self.enhanced_crit_value_dict[var_name] if v >= value}
                    elif comp == '>' and not neg:
                        target_val_set = {v for v in self.enhanced_crit_value_dict[var_name] if v > value}
                    else:
                        target_val_set = {v for v in self.enhanced_crit_value_dict[var_name] if v <= value}
                else:
                    # set variable
                    if not neg:
                        target_val_set = {value_str}
                    else:
                        target_val_set = {v for v in self.set_value_dict[var_name] if v != value_str}

                condition_index = self.var_list.index(var_name)
                condition_index_list.append(condition_index)
                condition_target_list.append(target_val_set)
            self.tap_condition_list.append((condition_index_list, condition_target_list))
        super(FastIoTSystem, self).__init__(timing_exp_list=[])

    def _getVarList(self):
        var_list = []
        for ch_name, channel in sorted(self.channel_dict.items()):
            for var_name, value in sorted(channel.state_dict.items()):
                var_list.append('%s.%s' % (ch_name, var_name))
        return var_list

    def _getCurrentTup(self):
        # var_type_dict = dict(zip(self.var_list, self.var_type_list))
        value_list = []
        for ch_name, channel in sorted(self.channel_dict.items()):
            for var_name, value in sorted(channel.state_dict.items()):
                cap_name = '%s.%s' % (ch_name, var_name)
                if self.var_type_dict[cap_name] == 'bool':
                    value_list.append(bool(value))
                elif self.var_type_dict[cap_name] == 'range':
                    value_list.append(float(value))
                else:
                    value_list.append(str(value))
        tb_list = [bool(tb) for ti, tb in sorted(self.trigger_dict.items())]
        return tuple(value_list), tuple(tb_list)

    def _applyActionFast(self, action, current_tuple):
        current_states = list(current_tuple[0])
        action_var, value_str = action.split('=')
        action_var_type = self.var_type_dict[action_var]
        if action_var_type == 'bool':
            action_value = value_str == 'true'
        elif action_var_type == 'range':
            action_value = float(value_str)
        else:
            action_value = str(value_str)
        action_var_index = self.var_index_dict[action_var]
        # first set trigger bits
        trigger_bits = list(current_tuple[1])
        for tap_index, trigger, condition in zip(range(len(self.tap_trigger_list)),
                                                 self.tap_trigger_list, self.tap_condition_list):
            if checkEventAgainstTrigger(action, trigger):
                cond_var_index_list, cond_var_target_list = condition
                if all([current_states[index] in target_set
                        for index, target_set in zip(cond_var_index_list, cond_var_target_list)]):
                    trigger_bits[tap_index] = True

        # then set the corresponding var bit
        current_states[action_var_index] = action_value
        return tuple(current_states), tuple(trigger_bits)

    def _applyTapActionFast(self, tap_index, current_tuple):
        action = self.tap_action_list[tap_index]
        current_states = list(current_tuple[0])
        action_var, value_str = action.split('=')
        action_var_type = self.var_type_dict[action_var]
        if action_var_type == 'bool':
            action_value = value_str == 'true'
        elif action_var_type == 'range':
            action_value = float(value_str)
        else:
            action_value = str(value_str)
        action_var_index = self.var_index_dict[action_var]

        # first resolve trigger bit
        trigger_bits = list(current_tuple[1])
        trigger_bits[tap_index] = False

        # second set trigger bits
        for tap_index, trigger, condition in zip(range(len(self.tap_trigger_list)),
                                                 self.tap_trigger_list, self.tap_condition_list):
            if trigger == action:
                cond_var_index_list, cond_var_target_list = condition
                if all([current_states[index] in target_set
                        for index, target_set in zip(cond_var_index_list, cond_var_target_list)]):
                    trigger_bits[tap_index] = True
        # then set the corresponding var bit
        current_states[action_var_index] = action_value
        return tuple(current_states), tuple(trigger_bits)

    def _checkNextActions(self, current_tuple):
        var_states, trigger_bits = current_tuple

        next_actions = list()
        if any(trigger_bits):
            # something is triggered
            for trigger_bit, tap_index in zip(trigger_bits, range(len(trigger_bits))):
                if trigger_bit:
                    next_actions.append((self.tap_action_list[tap_index],
                                        self._applyTapActionFast(tap_index, current_tuple)))
        else:
            for var_name, current_value, var_type in zip(self.var_list, var_states, self.var_type_list):
                if var_type == 'bool':
                    if current_value:
                        action = '%s=false' % var_name  # true -> false action
                    else:
                        action = '%s=true' % var_name  # false -> true action
                    next_actions.append((action, self._applyActionFast(action, current_tuple)))
                elif var_type == 'range':
                    for next_value in self.enhanced_crit_value_dict[var_name]:
                        if next_value != current_value:
                            action = '%s=%f' % (var_name, next_value)
                            next_actions.append((action, self._applyActionFast(action, current_tuple)))
                else:
                    for next_value in self.set_value_dict[var_name]:
                        if next_value != current_value:
                            action = '%s=%s' % (var_name, next_value)
                            next_actions.append((action, self._applyActionFast(action, current_tuple)))

        return next_actions

    def _tupToState(self, current_tup):
        var_states, trigger_bits = current_tup
        description_list = list()
        for var_name, value, var_type in zip(self.var_list, var_states, self.var_type_list):
            if var_type == 'bool':
                description_list.append(var_name + ('=1' if value else '=0'))
            else:
                description_list.append(var_name + '=' + str(value))
        # description_list = [var_name + ('=1' if value else '=0') for var_name, value in zip(self.var_list, var_states)]
        description_list = description_list + ['trigger_bit_' + tap_name + ('=1' if tb else '=0')
                                               for tap_name, tb in zip(self.tap_name_list, trigger_bits)]
        description = ', '.join(description_list)
        field = list(var_states + trigger_bits)
        # field = [int(v) for v in field]
        label = self._labelFromTup(current_tup)
        return TransitionSystem.State(field, description), label

    def _labelFromTup(self, tup):
        var_states, trigger_bits = tup
        label = list()
        for var_name, var_type, value in zip(self.var_list, self.var_type_list, var_states):
            if var_type == 'bool':
                label.append(value)
            elif var_type == 'range':
                for crit_value in self.crit_value_dict[var_name]:
                    label.append(value < crit_value)
                    label.append(value > crit_value)
            else:
                for set_value in self.set_value_dict[var_name]:
                    label.append(value == set_value)
        label.append(any(trigger_bits))
        return label

    def _tupsToTrans(self, tup1, action, tup2):
        index1 = self.state_index_dict[tup1]
        index2 = self.state_index_dict[tup2]
        return TransitionSystem.Transition(index1, action, index2)
    
    def _conditionSatisfied(self, condition):
        var, _, _ = splitSimpleFormula(condition)
        dev, cap = var.split('.')
        val = self.channel_dict[dev].state_dict[cap]
        return checkValueAgainstCondition(val, condition)

    def _createTS(self):
        ap_list = list()
        for var_name, var_type in zip(self.var_list, self.var_type_list):
            if var_type == 'bool':
                ap_list.append(var_name + '=true')
            elif var_type == 'range':
                crit_value_list = self.crit_value_dict[var_name]
                for crit_value in crit_value_list:
                    ap_list.append(var_name + '<%f' % crit_value)
                    ap_list.append(var_name + '>%f' % crit_value)
            else:
                ap_list = ap_list + [var_name + '=' + value for value in self.set_value_dict[var_name]]
        ap_list.append('_triggered')
        # ap_list = [var_name + '=true' for var_name in self.var_list] + self.tap_name_list + ['_triggered']
        self.transition_system = TransitionSystem.TS(ap_list)

        self.state_index_dict = dict()
        init_tup = self._getCurrentTup()

        init_state, init_label = self._tupToState(init_tup)
        self.state_index_dict[init_tup] = self.transition_system.addState(init_state, init_label)

        search_pool = [init_tup]
        current_search_index = 0
        while current_search_index < len(search_pool):
            current_tuple = search_pool[current_search_index]
            current_search_index = current_search_index + 1

            next_action_list = self._checkNextActions(current_tuple)
            for action, next_tuple in next_action_list:
                if not self.transition_system.ifActionExists(action):
                    self.transition_system.addAction(action)

                if next_tuple not in self.state_index_dict:
                    next_state, next_label = self._tupToState(next_tuple)
                    self.state_index_dict[next_tuple] = self.transition_system.addState(next_state, next_label)

                if next_tuple not in search_pool:
                    search_pool.append(next_tuple)

                trans = self._tupsToTrans(current_tuple, action, next_tuple)
                self.transition_system.addTrans(trans)


def generateFastIoTSystem(name, channel_dict, tap_dict, critical_value_dict={}, set_value_dict={}):
    class_name = 'Class' + name
    dct = {**channel_dict, **tap_dict}
    TempIoTSystem = MetaIoTSystem(class_name, (FastIoTSystem,), dct)
    result = TempIoTSystem(critical_value_dict, set_value_dict)
    return result
