from autotapmc.analyze.Build import getChannelListSimple, generateChannelDict, tapFormat
from autotapmc.channels.template.DbTemplate import template_dict
from autotapmc.model.IoTSystem import generateIoTSystem
from autotapmc.buchi.Buchi import tsToGenBuchi, ltlToBuchi, product
from autotapmc.utils.Boolean import xorGenerator, calculateBooleanZ3
import z3
import itertools


def checkModel(s, z3_var_dict):
    z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)
    while s.check() == z3.sat:
        m = s.model()
        z3_var_eval = dict([(k, m.evaluate(v)) if z3Interpreted(m.evaluate(v)) else (k, False)
                            for k, v in z3_var_dict.items()])
        print(z3_var_eval)
        s.add(z3.Or([v != z3_var_eval[k] for k, v in z3_var_dict.items()]))


def synthesizeSp(tap_list, channel_list=None, cap_list=None, template=template_dict):
    # Build the system
    if not channel_list or not cap_list:
        channel_list, cap_list = getChannelListSimple('', tap_list)
    channel_dict = generateChannelDict(channel_list, {}, {}, cap_list, template)
    tap_list = tapFormat(tap_list, {})
    tap_dict = {'rule' + str(key): value for key, value in zip(range(len(tap_list)), tap_list)}
    system = generateIoTSystem('Temp', channel_dict, tap_dict, [])
    buchi_ts = tsToGenBuchi(system.transition_system)

    # Build the ltl template
    ap_list = [ap for ap in system.transition_system.ap_list if '.' in ap]
    lambda_str_list = ['lambda_'+str(ii) for ii in range(len(ap_list))]
    eta_str_list = ['eta_'+str(ii) for ii in range(len(ap_list))]
    clause_list = ['(!%s | %s)' % (lbd, xorGenerator(eta, ap))
                   for lbd, eta, ap in zip(lambda_str_list, eta_str_list, ap_list)]
    ltl = 'F(' + ' & '.join(clause_list) + ')'
    buchi_ltl = ltlToBuchi(ltl)

    # Construct final graph
    (buchi_final, pairs) = product(buchi_ts, buchi_ltl)

    # Construct edge aps and bad edges
    bad_edges = list()
    var_dict_list = list()

    for index, edge in zip(range(len(buchi_final.edge_list)), buchi_final.edge_list):
        src_index_ts = pairs[edge.src][0]
        dst_index_ts = pairs[edge.dst][0]
        ap_ts = ''
        for edge_ts in buchi_ts.edge_list:
            if edge_ts.src == src_index_ts and edge_ts.dst == dst_index_ts:
                ap_ts = edge_ts.ap
                break
        ap_list = ap_ts.split(' & ')
        var_dict = dict()
        for ap in ap_list:
            if ap.startswith('!'):
                var_dict[ap[1:]] = False
            else:
                var_dict[ap] = True
        var_dict_list.append(var_dict)

        if not buchi_final.getStateAcc(edge.src) and buchi_final.getStateAcc(edge.dst) \
                and pairs[edge.src][0] != buchi_ts.init_state:
            bad_edges.append(index)

    z3_var_tuple = [(v, z3.Bool(v)) for v in lambda_str_list + eta_str_list]
    z3_var_dict = dict(z3_var_tuple)
    z3_node_exist_dict = dict()
    for ts_tup, ltl_tup in itertools.product(buchi_ts.state_dict.items(), buchi_ltl.state_dict.items()):
        ts_n = ts_tup[0]
        ltl_n = ltl_tup[0]
        var_name = 'phi_%d_%d' % (ts_n, ltl_n)
        z3_node_exist_dict[(ts_n, ltl_n)] = z3.Bool(var_name)

    # Z3 solver
    s = z3.Solver()

    # Bad edge constraints
    for edge_index in bad_edges:
        edge = buchi_final.edge_list[edge_index]
        src_index_ts = pairs[edge.src][0]
        src_index_ltl = pairs[edge.src][1]
        vd = var_dict_list[edge_index]
        total_dict = {**vd, **z3_var_dict}
        z3_cond = calculateBooleanZ3(edge.ap, total_dict)
        z3_cond = z3.And(z3_node_exist_dict[(src_index_ts, src_index_ltl)], z3_cond)
        s.add(z3.Not(z3_cond))

    # Node existence constraints
    for index_final, state_final in buchi_final.state_dict.items():
        index_ts = pairs[index_final][0]
        index_ltl = pairs[index_final][1]
        if index_final == buchi_final.init_state:
            s.add(z3_node_exist_dict[(index_ts, index_ltl)])
        else:
            z3_incoming_cond_list = list()
            for edge_index in range(len(buchi_final.edge_list)):
                edge = buchi_final.edge_list[edge_index]
                vd = var_dict_list[edge_index]
                if edge.dst == index_final:
                    total_dict = {**vd, **z3_var_dict}
                    z3_cond = calculateBooleanZ3(edge.ap, total_dict)
                    src_index_ts = pairs[edge.src][0]
                    src_index_ltl = pairs[edge.src][1]
                    z3_cond = z3.And(z3_node_exist_dict[(src_index_ts, src_index_ltl)], z3_cond)
                    z3_incoming_cond_list.append(z3_cond)

            z3_incoming_true = z3.Or(z3_incoming_cond_list)
            s.add(z3.Implies(z3_node_exist_dict[(index_ts, index_ltl)], z3_incoming_true))
            s.add(z3.Implies(z3_incoming_true, z3_node_exist_dict[(index_ts, index_ltl)]))

    # Constraint: eta only need to be set when lambda is true
    for lbd_name, eta_name in zip(lambda_str_list, eta_str_list):
        lbd = z3_var_dict[lbd_name]
        eta = z3_var_dict[eta_name]
        s.add(z3.Or(lbd, z3.Not(eta)))

    # Check the model
    checkModel(s, z3_var_dict)
