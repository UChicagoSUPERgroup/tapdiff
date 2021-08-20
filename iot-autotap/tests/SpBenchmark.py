from autotapmc.channels.template.SpBenchmarkRangeSet import template_dict
from autotapmc.analyze.Fix import generateCompactFix
import random
import itertools
import json


def writeResultToJson(filename, cap_dict, ltl1, ltl2, result1, result2):
    result = {'cap_dict': cap_dict, 'ltl1': ltl1, 'ltl2': ltl2}
    result1_list = list()
    for tap in result1:
        tap_dict = dict()
        tap_dict['trigger'] = tap.trigger
        tap_dict['condition'] = tap.condition
        tap_dict['action'] = random.choice(tap.action)
        result1_list.append(tap_dict)
    result2_list = list()
    for tap in result2:
        tap_dict = dict()
        tap_dict['trigger'] = tap.trigger
        tap_dict['condition'] = tap.condition
        tap_dict['action'] = random.choice(tap.action)
        result2_list.append(tap_dict)
    result['tap_list_1'] = result1_list
    result['tap_list_2'] = result2_list
    with open(filename, 'w') as outfile:
        json.dump(result, outfile)


cap_dict = dict()
for dev_name, dev_dict in template_dict.items():
    for var_name, var_type in dev_dict.items():
        cap_dict['%s.%s' % (dev_name, var_name)] = var_type
# 1. with different range value/comparator
#    (!d1.onoff=true & d2.onoff=true) -> d3.value>70 vs
#    (!d1.onoff=true & d2.onoff=true) -> d3.value>75
#    ===============================================
#    (!d1.onoff=true & d2.onoff=true) -> d3.value>70 vs
#    (!d1.onoff=true & d2.onoff=true) -> d3.value<70
ltl1 = '!G(!(!d1.onoff=true & d2.onoff=true) | d3.value>70)'
ltl2 = '!G(!(!d1.onoff=true & d2.onoff=true) | d3.value>75)'
result1 = generateCompactFix(ltl1, [], template_dict=template_dict)
result2 = generateCompactFix(ltl2, [], template_dict=template_dict)
writeResultToJson('temp/range_set_1.json', cap_dict, ltl1, ltl2, result1, result2)

ltl1 = '!G(!(!d1.onoff=true & d2.onoff=true) | d3.value>70)'
ltl2 = '!G(!(!d1.onoff=true & d2.onoff=true) | d3.value<70)'
result1 = generateCompactFix(ltl1, [], template_dict=template_dict)
result2 = generateCompactFix(ltl2, [], template_dict=template_dict)
writeResultToJson('temp/range_set_2.json', cap_dict, ltl1, ltl2, result1, result2)

# 2. with different set value
#    (d2.onoff=true) -> d5.setting=Option1 vs
#    (d2.onoff=true) -> d5.setting=Option2
#    ===============================================
#    never [d2.onoff=true & d5.setting=Option1] vs
#    never [d2.onoff=true & d5.setting=Option2]
ltl1 = '!G(!(d2.onoff=true) | d5.setting=Option1)'
ltl2 = '!G(!(d2.onoff=true) | d5.setting=Option2)'
result1 = generateCompactFix(ltl1, [], template_dict=template_dict)
result2 = generateCompactFix(ltl2, [], template_dict=template_dict)
writeResultToJson('temp/range_set_3.json', cap_dict, ltl1, ltl2, result1, result2)

ltl1 = 'F(d2.onoff=true & d5.setting=Option1)'
ltl2 = 'F(d2.onoff=true & d5.setting=Option2)'
result1 = generateCompactFix(ltl1, [], template_dict=template_dict)
result2 = generateCompactFix(ltl2, [], template_dict=template_dict)
writeResultToJson('temp/range_set_4.json', cap_dict, ltl1, ltl2, result1, result2)
# 3. with additional range values
#    (!d1.onoff=true & d2.onoff=true) -> (d3.value>70)
#    (!d1.onoff=true & d2.onoff=true) -> (d3.value>70 & d4.value<75)  # current TAP cannot handle d3.value in (70,75)
ltl1 = '!G(!(!d1.onoff=true & d2.onoff=true) | d3.value>70)'
ltl2 = '!G(!(!d1.onoff=true & d2.onoff=true) | (d3.value<70 & d4.value<75))'
result1 = generateCompactFix(ltl1, [], template_dict=template_dict)
result2 = generateCompactFix(ltl2, [], template_dict=template_dict)
writeResultToJson('temp/range_set_5.json', cap_dict, ltl1, ltl2, result1, result2)
# 4. with additional set value
#    (d2.onoff=true) -> !d5.setting=Option1
#    (d2.onoff=true) -> (!d5.setting=Option1 & !d5.setting=Option2)
ltl1 = '!G(!(d2.onoff=true) | !d5.setting=Option1)'
ltl2 = '!G(!(d2.onoff=true) | (!d5.setting=Option1 & !d5.setting=Option2))'
result1 = generateCompactFix(ltl1, [], template_dict=template_dict)
result2 = generateCompactFix(ltl2, [], template_dict=template_dict)
writeResultToJson('temp/range_set_6.json', cap_dict, ltl1, ltl2, result1, result2)
#
# with open('temp/%s_%s_%s_compare.json' % (num_var, num_ap, max_split), 'w') as outfile:
#     json.dump(result, outfile)
# js_result = json.dumps(result)
