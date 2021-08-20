import random
import json
import re
import ast
from autotapmc.model import Tap
from autotapmc.analyze.Build import generateChannelDict, generateCriticalValue, getSetOptions, getChannelListSimple
from autotapmc.model.IoTSystemForDiff import generateFastIoTSystem
from autotapmc.buchi.Buchi import tsToGenBuchi
from sympy.logic import simplify_logic
# There is no name collision so import * is okay
from .StateSpFns import *
from .NodeToDevStates import *
from .EdgeSpFns import *

################################################
########## For edge-based properties ##########
################################################

class EdgeSpInfo:
    '''Has: unreach_set_1, unreach_set_2, shared_unreach_set, unshared_unreach_set1, unshared_unreach_set2.'''
    def __init__(self, reach_set_i, trigger_set_i, edges):
        self.reach_set_i = reach_set_i
        self.trigger_set_i = trigger_set_i
        self.edges = edges

def isRedirectedFromUnrNode(esi, edge):
    ''' Whether the edge is r_node -> T_node i.e. coming out of reachable nodes (as opposed to T_node -> elsewhere).
    source is a r_node and destination is a Trigger node that represents an r_node.
    edge is a BuchiEdge obj, 
    t_nodes_dict is the dict with t_node indices as keys and their dev states + triggered rules as values,
    r_nodes_i is the indices of r_nodes.'''

    return (edge.src_index in esi.reach_set_i) and (edge.dst_index not in esi.reach_set_i) and (edge.dst_index in esi.trigger_set_i)
    # return edge.src_index in reach_set and edge.dst_index in trigger_set

def isRedundantlyRedirectedEdge(system, esi, edge):
    ''' Whether the edge is T_node -> equivalent r_node (i.e. T is just on the path of what the edge would've been).
    Returns if an edge fulfills the following property:
    source is a Trigger node and destination is the r_node that it represents.
    edge is a BuchiEdge obj, 
    t_r_map is the mapping between trigger nodes (keys) and reachable nodes (vals) they represent,
    '''
    # description1 = sorted([s for s in state_list[edge.src_index].description.split(', ') if not s.startswith('trigger')])
    # description2 = sorted([s for s in state_list[edge.dst_index].description.split(', ') if not s.startswith('trigger')])
    description1 = system.getPureStateList(system.transition_system.state_list[edge.src_index].field) 
    description2 = system.getPureStateList(system.transition_system.state_list[edge.dst_index].field) 
    sameField = description1 == description2
    return (edge.src_index in esi.trigger_set_i) and (edge.dst_index in esi.reach_set_i) and sameField

def getAllUndoingEdges(system, esi):
    ''' All self-transitions (except for those that were redundant).'''
    redir_edges = set()  # each edge is (r_node src ind, T_node dst ind)
    candidates, redundant_bad_edges = [], []
    
    edge_list = esi.edges
    for edge in esi.edges:
        if isRedirectedFromUnrNode(esi, edge): # r_node -> T_node (which doesn't have to represent a r_node)
            outgoing_edge = [
                e for e in edge_list if e.src_index == edge.dst_index] # edge that comes out of this exact dst T node
            for oe in outgoing_edge: # edge.src_index -- edge.dst_index/oe.src_index -- oe.dst_index
                if oe.dst_index == edge.src_index:  # i.e. something is undone: oe.src_index == edge.dst_index and oe.dst_index == edge.src_index
                    singularly_replaced_edge = (
                        edge.src_index, edge.dst_index)
                    candidates.append(singularly_replaced_edge)
        elif isRedundantlyRedirectedEdge(system, esi, edge): # T_node -> [r_node represented by this T_node]
            # the represented r_node, not the T node
            redundant_bad_edges.append(edge.dst_index)
    for singularly_replaced_edge in candidates:
        if singularly_replaced_edge[1] not in redundant_bad_edges:
            redir_edges.add(singularly_replaced_edge)
    return redir_edges

def getEdgeSpInfo(system, edge):
    ''' Returns an ((action_index, event), src_node).'''
    src_node = system.getPureStateList(system.transition_system.state_list[edge[0]].field) 
    dst_node = system.getPureStateList(system.transition_system.state_list[edge[1]].field) 

    action_index = -1
    for i in range(len(src_node)): # assuming that both ts have same ap (same length and order to the field)
        if src_node[i] != dst_node[i]:
            if action_index != -1:
                print("There is more than one action! Ignoring action %d " % i)
            else:
                action_index = i

    return ((action_index, dst_node[action_index]), src_node)

def constructSpInfo(system_1, system_2, template_dict):
    reach_set_1 = {system_1.getPureStateList(state.field) 
                   for state in system_1.transition_system.state_list 
                   if not system_1.isTriggeredState(state.field)}
    reach_set_2 = {system_2.getPureStateList(state.field) 
                   for state in system_2.transition_system.state_list 
                   if not system_2.isTriggeredState(state.field)}
    
    assert(all([system_1.var_type_dict[v]=='bool' for v in system_1.var_list]), 'We have not handled range nor set vars yet :)')
    all_nodes = set()
    n = len(system_1.var_list)
    for i in range(2**n):
        all_nodes.add(tuple([int(x) for x in list(('{0:>0'+str(n)+'b}').format(i))]))
    unreach_set_1 = all_nodes - reach_set_1
    unreach_set_2 = all_nodes - reach_set_2
    shared_unreach_set = unreach_set_1.intersection(unreach_set_2)
    unshared_unreach_set1 = unreach_set_1 - unreach_set_2
    unshared_unreach_set2 = unreach_set_2 - unreach_set_1
    ssi = StateSpInfo(unreach_set_1, unreach_set_2, shared_unreach_set, unshared_unreach_set1, unshared_unreach_set2)

    # For edge sps later
    reach_set_i1 = {i for i in range(len(system_1.transition_system.state_list))
                    if not system_1.isTriggeredState(system_1.transition_system.state_list[i].field)}
    reach_set_i2 = {i for i in range(len(system_2.transition_system.state_list))
                    if not system_2.isTriggeredState(system_2.transition_system.state_list[i].field)}
    trigger_set_i1 = {i for i in range(len(system_1.transition_system.state_list))
                    if system_1.isTriggeredState(system_1.transition_system.state_list[i].field)}
    trigger_set_i2 = {i for i in range(len(system_2.transition_system.state_list))
                    if system_2.isTriggeredState(system_2.transition_system.state_list[i].field)}
    edges1 = system_1.transition_system.trans_list
    edges2 = system_2.transition_system.trans_list
    esi1 = EdgeSpInfo(reach_set_i1, trigger_set_i1, edges1)
    esi2 = EdgeSpInfo(reach_set_i2, trigger_set_i2, edges2)

    return (ssi, esi1, esi2)


def groupEdgesByEvent(system, edges):
    edges_info = [getEdgeSpInfo(system, e) for e in edges]
    edges_info_by_event = {}
    for ei in edges_info:
        if ei[0] not in edges_info_by_event:
            edges_info_by_event[ei[0]] = set()
        edges_info_by_event[ei[0]].add(ei[1])
    grouped_edges_info_by_event = {}
    for event in edges_info_by_event:
        grouped_edges_info_by_event[event] = minStates(edges_info_by_event[event], event[0]) # event = (action_index, 0/1 indicating event)
    return grouped_edges_info_by_event


def getEdgeSps(grouped_edges_info_by_event, ap_list):
    sps = set()
    for e in grouped_edges_info_by_event: # e = (action_index, 0/1 indicating event i.e. t/f)
        event = ap_list[e[0]].split('=')[0]+'='+('true' if e[1]==1 else 'false')
        states = minStatesToSps(grouped_edges_info_by_event[e], ap_list)
        for s in states:
            sps.add((event, s))
    return sps


def edgeSpImpliedByStateSp(edge_sp, state_sp, template_dict):
    ''' Check that the edge action has same dev as the sp first (and only int) state and ALL ext while caps included in the state sp ext while caps?'''
    assert(state_sp['type'] != 3), "state sp has type 3...? %s" % (str(state_sp))
    if state_sp['type']==1: # XYZ never together
        assert(state_sp['always']==False), "what type 1 sp (XYZ together) has always? %s" % (str(state_sp))
        # if only one int var, ex. lights always on at night, then should be type 2 instead
        assert(len(getIntVars(state_sp['caps'], template_dict))!=1), "i thought we made 1-int var never-together sps type 2-always instead: %s" % (state_sp['caps'])
        # can't check, because caps len > 1 and int vars > 1
        # ex. state_sp = ac on and heater on never together, edge_sp = ac never turn on/off while heater is on
        [state_param, _] = state_sp['caps'][0].split('=')
        return False 
    elif state_sp['type']==2: # X always active while YZ
        if len(state_sp['caps'])!=1: # if only 1 elt, we can def for imp rel
            # if X is not int var (technically impossible, but) or YZ are not ALL ext vars
            if len(getIntVars([state_sp['caps'][0]], template_dict))!=1 or len(getIntVars(state_sp['caps'][1:], template_dict))!=0:
                return False
        state_param = state_sp['caps'][0].split('=')[0]
        edge_param = edge_sp[0].split('=')[0] # always of type 'never'
        if len(state_sp['caps'])==1:
            return state_param==edge_param
        else:
            return state_param==edge_param and set(state_sp['caps'][1:]).issubset(set(edge_sp[1]))
        # TODO: ignoring sets/range...
    else:
        assert(False), "what state_sp is this in edgeSpImpliedByStateSp? %s" % (str(state_sp))    
    return False


def filterEdgeSpsBasedOnStateSps(edge_sps, state_sps, template_dict):
    ''' Get just the edge_sps that are not implied by any given state_sps.'''
    if len(edge_sps) == 0 or len(state_sps) == 0: # nothing to see here
        return edge_sps
    new_edge_sps = []
    for edge_sp in edge_sps:
        notRedundant = True
        for state_sp in state_sps:
            if edgeSpImpliedByStateSp(edge_sp, state_sp, template_dict):
                notRedundant = False
                break
        if notRedundant:
            new_edge_sps.append(edge_sp)
    return new_edge_sps


def getSps(system_1, system_2, union_ap_list, template_dict):
    (ssi, esi1, esi2) = constructSpInfo(system_1, system_2, template_dict)

    sh_never_groups, sh_never_sps, sh_state_sps = set(), set(), []
    never_groups1, never_sps1, state_sps1 = set(), set(), []
    never_groups2, never_sps2, state_sps2 = set(), set(), []
    if ssi.shared_unreach_set != set():
        sh_never_groups = minStates(ssi.shared_unreach_set)
        sh_never_sps = minStatesToSps(sh_never_groups, union_ap_list)
        sh_state_sps = stateSpInAlwaysForm(sh_never_sps, template_dict)
    if ssi.unshared_unreach_set1 != set():
        never_groups1 = minStates(ssi.unreach_set_1)
        never_sps1 = minStatesToSps(never_groups1, union_ap_list) - sh_never_sps
        state_sps1 = stateSpInAlwaysForm(never_sps1, template_dict) # can have 'always' sps
    if ssi.unshared_unreach_set2 != set():
        never_groups2 = minStates(ssi.unreach_set_2)
        never_sps2 = minStatesToSps(never_groups2, union_ap_list) - sh_never_sps
        state_sps2 = stateSpInAlwaysForm(never_sps2, template_dict) # can have 'always' sps

    edges1 = getAllUndoingEdges(system_1, esi1)
    edges2 = getAllUndoingEdges(system_2, esi2)
    sh_edges = edges1.intersection(edges2)

    sh_edge_sps = getEdgeSps(groupEdgesByEvent(system_1, sh_edges), union_ap_list)
    edge_sps1 = getEdgeSps(groupEdgesByEvent(system_1, edges1), union_ap_list) - sh_edge_sps
    edge_sps2 = getEdgeSps(groupEdgesByEvent(system_2, edges2), union_ap_list) - sh_edge_sps

    # Filter out edges that point to unr nodes (those already accounted for by state sps)
    edge_sps1 = filterEdgeSpsBasedOnStateSps(edge_sps1, state_sps1 + sh_state_sps, template_dict)
    edge_sps2 = filterEdgeSpsBasedOnStateSps(edge_sps2, state_sps2 + sh_state_sps, template_dict)
    sh_edge_sps = filterEdgeSpsBasedOnStateSps(sh_edge_sps, sh_state_sps, template_dict)

    # Now minimize over the edges to identify the smallest set of sps that cover all edges
    edge_sps1 = minEdgeSps(edge_sps1, ssi.unreach_set_1, system_1)
    edge_sps2 = minEdgeSps(edge_sps2, ssi.unreach_set_2, system_2)
    sh_edge_sps = minEdgeSps(sh_edge_sps, ssi.shared_unreach_set, system_1)

    final_edge_sps1 = getFinalEdgeSps(list(edge_sps1))
    final_edge_sps2 = getFinalEdgeSps(list(edge_sps2))
    final_sh_edge_sps = getFinalEdgeSps(list(sh_edge_sps))

    sps1 = state_sps1 + final_edge_sps1
    sps2 = state_sps2 + final_edge_sps2
    sh_sps = sh_state_sps + final_sh_edge_sps
    return ([(sp, [-1]) for sp in sps1], [(sp, [-1]) for sp in sps2], [(sp, [-1]) for sp in sh_sps])


def genSystems(tap_list1, tap_list2, template_dict, init_state_dict):
    ltl_formula = '!(0)'
    crit_value_dict = generateCriticalValue(ltl_formula, tap_list1 + tap_list2, with_timing_ops=False)
    set_value_dict = getSetOptions(template_dict)

    # getChannelListSimple instead of getChannelList that was in TimelineDiff.compareRulesOrig()
    channel_name_list, cap_name_list = getChannelListSimple(ltl_formula, tap_list1 + tap_list2)
    if init_state_dict:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           init_state_dict, cap_name_list, template_dict)
    else:
        channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                           {}, cap_name_list, template_dict)

    tap_dict_1 = {str(ii): tap for ii, tap in zip(range(len(tap_list1)), tap_list1)}
    tap_dict_2 = {str(ii): tap for ii, tap in zip(range(len(tap_list2)), tap_list2)}

    # system_1 = generateIoTSystem('TempSystem', channel_dict, tap_dict_1, exp_t_list)
    system_1 = generateFastIoTSystem('TempSystem', channel_dict, tap_dict_1, crit_value_dict, set_value_dict)
    system_1._restoreFromStateVector(system_1.transition_system.getField(0))

    # system_2 = generateIoTSystem('TempSystem', channel_dict, tap_dict_2, exp_t_list)
    system_2 = generateFastIoTSystem('TempSystem', channel_dict, tap_dict_2, crit_value_dict, set_value_dict)
    system_2._restoreFromStateVector(system_2.transition_system.getField(0))

    system = generateFastIoTSystem(
        'TempSystem', channel_dict, {}, crit_value_dict, set_value_dict)

    return (system, system_1, system_2)


def spDiffForTaps(tap_list1, tap_list2, template_dict, init_state_dict=None):
    (system, system_1, system_2) = genSystems(tap_list1, tap_list2, template_dict, init_state_dict)
    return getSps(system_1, system_2, system.transition_system.ap_list, template_dict)


def compareSps(tap_list1, tap_list2, template_dict, task=None, version_1=None, version_2=None):
    # get init states
    if task is not None and version_1 is not None and version_2 is not None:
        json_init_file = '../diff_init/init_%s.json' % str(task)
        with open(json_init_file, 'r') as fp:
            init_state_dict = json.load(fp)
            # The init state should be the same for every version
            init_state_dict = init_state_dict['0'] #str(version_1)]
    else:
        init_state_dict = None
    return spDiffForTaps(tap_list1, tap_list2, template_dict, init_state_dict)