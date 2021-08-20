### Generate toy examples (dif_dev_%d_compare.json) ###

import json

# 0: Identical sets of devices (try for a single missing edge too that doesn't overlap with the unreachable states)
# sp 1: 1 & 2 on never 
# sp 2: never turn on 1 when 3 is on
cap_picked_a = ['d1.onoff', 'd2.onoff', 'd3.onoff']
unreachable_comb_1_a = ['d1.onoff=true', 'd2.onoff=true']
tap_list_1_a = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
unreachable_comb_2_a = []#['d1.onoff=true', 'd2.onoff=true']
tap_list_2_a = [{'trigger':'d1.onoff=true', 'condition':['d3.onoff=true'],'action':'d1.onoff=false'}]
res_a = {'cap_list': cap_picked_a, 'unreachable_combination_1': unreachable_comb_1_a, 'tap_list_1': tap_list_1_a,
          'unreachable_combination_2': unreachable_comb_2_a, 'tap_list_2': tap_list_2_a}

# 1: Two sets do not overlap
cap_picked_1_b = ['d1.onoff', 'd2.onoff', 'd3.onoff']
unreachable_comb_1_b = ['d1.onoff=true', 'd2.onoff=true']
tap_list_1_b = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
cap_picked_2_b = ['d8.onoff', 'd9.onoff']
unreachable_comb_2_b = ['d8.onoff=true', 'd9.onoff=true']
tap_list_2_b = [{'trigger':'d8.onoff=true', 'condition':['d9.onoff=true'],'action':'d8.onoff=false'},
                {'trigger':'d9.onoff=true', 'condition':['d8.onoff=true'],'action':'d8.onoff=false'}]
res_b = {'cap_list1': cap_picked_1_b, 'unreachable_combination_1': unreachable_comb_1_b, 'tap_list_1': tap_list_1_b,
          'cap_list2': cap_picked_2_b, 'unreachable_combination_2': unreachable_comb_2_b, 'tap_list_2': tap_list_2_b}

# 2: One set of devices is subset of another, but sps don't overlap in terms of unreachable nodes
cap_picked_1_c = ['d1.onoff', 'd2.onoff', 'd3.onoff']
unreachable_comb_1_c = ['d1.onoff=true', 'd2.onoff=true']
tap_list_1_c = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
cap_picked_2_c = ['d1.onoff', 'd3.onoff']
unreachable_comb_2_c = ['d1.onoff=true', 'd3.onoff=true']
tap_list_2_c = [{'trigger':'d1.onoff=true', 'condition':['d3.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d3.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
res_c = {'cap_list1': cap_picked_1_c, 'unreachable_combination_1': unreachable_comb_1_c, 'tap_list_1': tap_list_1_c,
          'cap_list2': cap_picked_2_c, 'unreachable_combination_2': unreachable_comb_2_c, 'tap_list_2': tap_list_2_c}

# 3: One set of devices is subset of another, and sps overlap
cap_picked_1_d = ['d1.onoff', 'd2.onoff', 'd3.onoff']
unreachable_comb_1_d = ['d1.onoff=true', 'd2.onoff=true']
tap_list_1_d = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
cap_picked_2_d = ['d1.onoff', 'd2.onoff']
unreachable_comb_2_d = ['d1.onoff=true', 'd2.onoff=true']
tap_list_2_d = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d2.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d2.onoff=false'}]
res_d = {'cap_list1': cap_picked_1_d, 'unreachable_combination_1': unreachable_comb_1_d, 'tap_list_1': tap_list_1_d,
          'cap_list2': cap_picked_2_d, 'unreachable_combination_2': unreachable_comb_2_d, 'tap_list_2': tap_list_2_d}

# 4: Two sets have overlap but are not subsets, and sp are dif
cap_picked_1_e = ['d1.onoff', 'd2.onoff', 'd3.onoff']
unreachable_comb_1_e = ['d1.onoff=true', 'd2.onoff=true']
tap_list_1_e = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
cap_picked_2_e = ['d1.onoff', 'd2.onoff', 'd4.onoff']
unreachable_comb_2_e = ['d1.onoff=true', 'd4.onoff=true']
tap_list_2_e = [{'trigger':'d1.onoff=true', 'condition':['d4.onoff=true'],'action':'d4.onoff=false'},
                {'trigger':'d4.onoff=true', 'condition':['d1.onoff=true'],'action':'d4.onoff=false'}]
res_e = {'cap_list1': cap_picked_1_e, 'unreachable_combination_1': unreachable_comb_1_e, 'tap_list_1': tap_list_1_e,
          'cap_list2': cap_picked_2_e, 'unreachable_combination_2': unreachable_comb_2_e, 'tap_list_2': tap_list_2_e}

# 5: Two sets have overlap but are not subsets, but sp are same
cap_picked_1_f = ['d1.onoff', 'd2.onoff', 'd3.onoff']
unreachable_comb_1_f = ['d1.onoff=true', 'd2.onoff=true']
tap_list_1_f = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d1.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d1.onoff=false'}]
cap_picked_2_f = ['d1.onoff', 'd2.onoff', 'd4.onoff']
unreachable_comb_2_f = ['d1.onoff=true', 'd2.onoff=true']
tap_list_2_f = [{'trigger':'d1.onoff=true', 'condition':['d2.onoff=true'],'action':'d2.onoff=false'},
                {'trigger':'d2.onoff=true', 'condition':['d1.onoff=true'],'action':'d2.onoff=false'}]
res_f = {'cap_list1': cap_picked_1_f, 'unreachable_combination_1': unreachable_comb_1_f, 'tap_list_1': tap_list_1_f,
          'cap_list2': cap_picked_2_f, 'unreachable_combination_2': unreachable_comb_2_f, 'tap_list_2': tap_list_2_f}

res = [res_a, res_b, res_c, res_d, res_e, res_f]

for i in range(len(res)):
    with open('benchmarks/diff/dif_dev_%s_compare.json' % (i), 'w') as outfile:
        json.dump(res[i], outfile)
    js_result = json.dumps(res[i])
