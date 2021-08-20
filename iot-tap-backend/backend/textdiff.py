import difflib
from functools import reduce
import itertools as it

# Indicate whether a rule or a clause was deleted, added, shared, or changed.
DEL_CODE = -1
SHARE_CODE = 0
ADD_CODE = 1
PARTIAL_DEL_CODE = 21
PARTIAL_ADD_CODE = 22


def findTrigger(rule):
    return rule['ifClause'][0]


def findTriggerText(rule):
    '''Given a rule (dictionary with keys 'id', 'ifClause', 'thenClause', 'temporality'),
    find the trigger text in the ifClause (which has both the trigger and the conditions).'''
    return findTrigger(rule)['text']


def getIfClausesTexts(rule):
    ''' Returns list of clauses (text)'''
    clauses = sorted([clause for clause in rule['ifClause']], key=lambda x:x['id']) # [0] = trigger
    # if (len(rule['ifClause']) > 1):
    #     clauses_sorted_by_id = sorted(
    #         [clause for clause in rule['ifClause']], key=lambda x: x['id'])  # [0] = trigger
    #     clauses = [clauses_sorted_by_id[0]] + \
    #         sorted([clause for clause in clauses_sorted_by_id[1:]],
    #                key=lambda x: x['text'])
    # else:
    #     clauses = rule['ifClause']
    return [clause['text'] for clause in clauses]


def getThenClauseText(rule):
    ''' Returns list of clauses (text). '''
    action = [clause['text'] for clause in rule['thenClause']]
    assert(len(action) ==
           1), 'Hmm there should only be one action in the rule? %s' % str(action)
    return action


class Rule:
    def __init__(self, rule_dict, ind):
        self.rule = rule_dict
        self.index = ind

    def sameIf(self, Rule2):
        return getIfClausesTexts(self.rule) == getIfClausesTexts(Rule2.rule)

    def sameThen(self, Rule2):
        return getThenClauseText(self.rule) == getThenClauseText(Rule2.rule)

    def sameTemp(self, Rule2):
        return self.rule['temporality'] == Rule2.rule['temporality']

    def setRuleStatus(self, statusCode):
        # -1 = deleted, 0 = shared, 1 = added, 2 = partially changed
        self.rule['status'] = statusCode

    def setPairingCode(self, ind):
        ''' ind should be the index of the rule in the FIRST program '''
        self.rule['pairingCode'] = ind

    def __eq__(self, Rule2):
        return (self.sameIf(Rule2) and self.sameThen(Rule2) and self.sameTemp(Rule2))

    def __key(self):
        ''' Ex. "condition1, trigger, condition2, action: temporality" 
        (in id order to make it unique). Two rules with the same conditions but in dif order of conditions
        should not be equivalent since we want textdiff.'''
        ifClauseTexts = getIfClausesTexts(self.rule)
        thenClauseTexts = getThenClauseText(self.rule)
        return ': '.join([', '.join(ifClauseTexts + thenClauseTexts), self.rule['temporality']])

    def getClauses(self):
        trigger = findTrigger(self.rule)
        # sorted([x for x in self.rule['ifClause'] if (' is ' in x['capability']['label'])], key=lambda x:x['id'])
        conditions = self.rule['ifClause'][1:]
        action = self.rule['thenClause'][0]
        return {'trigger': trigger, 'conditions': conditions, 'action': action}

    def getClausesTextList(self):
        ''' Each Rule obj is represented as a list of the clauses,
        ex. "If trigger while condition1 and condition2 then action." '''
        trigger = ['If '+findTriggerText(self.rule)]
        conditions_reps = self.rule['ifClause'][1:]
        # conditions_reps = sorted([x for x in self.rule['ifClause'] if (' is ' in x['capability']['label'])], key=lambda x:x['id'])
        # Despite how we'd display the first with 'while',
        # all conditions here should be preceded with 'and' since they're equivalent
        # this helps ensure that the text comparison 'while X' and 'and X' as equivalent
        conditions = ['and '+conditions_reps[i]['text']
                      for i in range(len(conditions_reps))]
        action = ['then '+self.rule['thenClause'][0]['text']+'.']
        return trigger+conditions+action  # list of clauses

    def __repr__(self):
        ''' Need to return a str. '''
        return ' '.join(self.getClausesTextList())

    def __hash__(self):
        return hash(self.__key())


def assignClauseStatus(c1, c2):  # clauses={} or conditions=[{}] or both
    ''' NOTE: this fn changes c1/c2. It sets the status of the two clauses (add/del/shared).'''

    assert(type(c1) == type(
        c2)), 'c1 and c2 are not the same TYPE of clauses: %s vs. %s' % (c1, c2)
    lst_type = type([])
    if type(c1) != lst_type and type(c2) != lst_type:  # both are clauses
        equivClauses = c1['text'] == c2['text']
        c1['status'] = SHARE_CODE if equivClauses else DEL_CODE
        c2['status'] = SHARE_CODE if equivClauses else ADD_CODE
    elif type(c1) == lst_type and type(c2) == lst_type:  # both are conditions
        conds1 = set([c['text'] for c in c1])
        conds2 = set([c['text'] for c in c2])
        overlap = conds1 & conds2
        for cc1 in c1:
            shared1 = cc1['text'] in overlap
            cc1['status'] = SHARE_CODE if shared1 else DEL_CODE
        for cc2 in c2:
            shared2 = cc2['text'] in overlap
            cc2['status'] = SHARE_CODE if shared2 else ADD_CODE


def findNumDifClauses(c1, c2):  # clauses={} or conditions=[{}] or both
    '''Returns the number of clauses different between the two 
    (if 'if/then' then either 0/1, if 'while' then could be more).'''

    assert(type(c1) == type(
        c2)), 'c1 and c2 are not the same TYPE of clauses: %s vs. %s' % (c1, c2)
    lst_type = type([])
    if type(c1) != lst_type and type(c2) != lst_type:  # both are clauses
        equivClauses = c1['text'] == c2['text']
        return 0 if equivClauses else 1

    elif type(c1) == lst_type and type(c2) == lst_type:  # both are conditions
        conds1 = set([c['text'] for c in c1])
        conds2 = set([c['text'] for c in c2])
        return max([len(conds1-conds2), len(conds2-conds1)])


def clausesAreEqual(c1, c2):  
    ''' clauses={} or conditions=[{}]'''
    lst_type = type([])
    if type(c1) != lst_type and type(c2) != lst_type:  # both are clauses
        return c1['text'] == c2['text']

    elif type(c1) == lst_type and type(c2) == lst_type:  # both are conditions
        return set([c['text'] for c in c1])==set([c['text'] for c in c2])


def calcNumDifBetweenRulesOutOf3(del_rule, add_rule):
    ''' Rule A is changed to rule B if both have only one clause that differs. (In this context the list of conditions is 
       considered as a single clause.)'''
    del_rule_clauses = del_rule.getClauses()
    add_rule_clauses = add_rule.getClauses()
    sameTrigger = clausesAreEqual(
        del_rule_clauses['trigger'], add_rule_clauses['trigger'])
    sameConditions = clausesAreEqual(
        del_rule_clauses['conditions'], add_rule_clauses['conditions'])
    sameAction = clausesAreEqual(
        del_rule_clauses['action'], add_rule_clauses['action'])

    # only one different
    return len([x for x in [sameTrigger, sameConditions, sameAction] if not x])


def calcIfTwoRulesRelated(del_rule, add_rule):
    return calcNumDifBetweenRulesOutOf3(del_rule, add_rule) <= 1


def findPairedRule(rules, pairingCode):
    ''' Given a pairing code (from a modified rule), find its paired rule.
    Ex. if given pairing code from a del-mod rule, find the add-mod rule that comes from it.'''
    for r in rules:
        if ('pairingCode' in rules[r].rule) and (rules[r].rule['pairingCode'] == pairingCode):
            return rules[r]
    assert(False), 'pairingCode not found: %d' % pairingCode


def pairwiseCompare(delRules, addRules):
    ''' run pairwise comparison of two sets of rules and return a dict {pair:intrapair_dif_num}'''
    del_add_pairs = set(it.product(list(delRules.items()),
                                   list(addRules.items())))  # set of tups
    dif_record = {}
    for (d, a) in del_add_pairs:
        del_rule, add_rule = d[1], a[1]
        if calcIfTwoRulesRelated(del_rule, add_rule):
            del_rule_clauses = del_rule.getClauses()
            add_rule_clauses = add_rule.getClauses()
            dif = findNumDifClauses(del_rule_clauses['trigger'], add_rule_clauses['trigger'])\
                + findNumDifClauses(del_rule_clauses['conditions'], add_rule_clauses['conditions'])\
                + findNumDifClauses(del_rule_clauses['action'],
                                    add_rule_clauses['action'])  # num clauses that are dif
            dif_record[(d, a)] = dif
    return dif_record


def genRelevantPowerset(input_set):
    ''' Given an input_set, generate a powerset. Optional args specify 
    the number of items in each set of the powerset, and whether it should
    be a combination (default) or permutation. 
    Returns a list of tuples, each tuple sorted.'''
    ps = list(it.chain.from_iterable(it.combinations(input_set, r)
                                     for r in range(1, len(input_set)+1)))  # list of tuples
    # sort by alphabetic order, and then by length (which is stable and thus preserves alphabetic order when possible)
    ps_sorted = sorted(sorted(ps), key=len, reverse=True)
    return ps_sorted


def findDif(delRules, addRules):
    ''' Given two sets of rules, each in the form of {index in orig program : Rule},
    '''
    dif_record = pairwiseCompare(delRules, addRules)

    # key = intrapair dif, value = set of pairs w/ this intrapair dif
    # each pair = (rule index in prgm : Rule)
    intrapairs_by_dif = {}
    for k, v in dif_record.items():
        if v not in intrapairs_by_dif:
            intrapairs_by_dif[v] = set()
        intrapairs_by_dif[v].add(k)

    # now that we have the pairs with the smallest intrapair difs...
    # 1. For pairs with the smallest intrapair dif, find a/the combo that covers the most of these pairs without overlaps
    # 2. If we've used up all the pairs with smallest intrapair difs,
    # but there's still some pairs with slightly bigger difs that won't overlap (so that we don't have too many leftover rules)
    # then let's use those
    # --> wait, would it be possible that there's more leftover rules this way?
    min_dif = min(intrapairs_by_dif.keys())

    # brute-forcing it (greedy algr?): get powerset of all combos of pairs (w/ smallest intrapair dif),
    # sort from large to small, stop at the first that doesn't overlap
    # (note that this has to be sorted somehow to make it deterministic)
    powerset = genRelevantPowerset(intrapairs_by_dif[min_dif])

    # a combo with the most pairs that doesn't have overlapping rules
    best_ok_combo = tuple()
    for combo in powerset:  # pseudo ex: ((1,1), (2,2), (3,3), (4,4))
        # check that the combo of pairs satisfy the following quality:
        # it only selects unique rules within the first program (p[0] of each pair) and unique rules within the second (p[1])
        if len([p[0] for p in combo]) == len(set([p[0] for p in combo])) \
                and len([p[1] for p in combo]) == len(set([p[1] for p in combo])):
            best_ok_combo = combo
            break

    final_combo = set(best_ok_combo)
    # check thru the rest of the pairs to see if there are any more pairs we can add and minimize leftover rules
    for k in sorted(list(intrapairs_by_dif.keys()), reverse=True):
        if k != min_dif:
            for pair in intrapairs_by_dif[k]:
                # just index and just list is fine
                del_rules_covered = [p[0][0] for p in final_combo]
                add_rules_covered = [p[1][0] for p in final_combo]
                if pair[0][0] not in del_rules_covered and pair[1][0] not in add_rules_covered:
                    final_combo.add(pair)

    # assign labels now
    pairingCode = 0
    for ((_, r1), (_, r2)) in final_combo:
        r1_clauses, r2_clauses = r1.getClauses(), r2.getClauses()
        assignClauseStatus(r1_clauses['trigger'], r2_clauses['trigger'])
        assignClauseStatus(r1_clauses['conditions'], r2_clauses['conditions'])
        assignClauseStatus(r1_clauses['action'], r2_clauses['action'])
        r1.setRuleStatus(PARTIAL_DEL_CODE)
        r2.setRuleStatus(PARTIAL_ADD_CODE)
        r1.setPairingCode(pairingCode)
        r2.setPairingCode(pairingCode)
        pairingCode += 1
    for (_, r) in list(delRules.items()):  # should be list of tups
        if 'status' not in r.rule:
            r.setRuleStatus(DEL_CODE)
    for (_, r) in list(addRules.items()):
        if 'status' not in r.rule:
            r.setRuleStatus(ADD_CODE)
    return (delRules, addRules)


def addToRulelst2Order(result2, rulelst2_order, rulelst2, rule2):
    ''' NOTE: Modifies result2 and rulelst2_order'''
    assert(len(result2)==len(rulelst2_order)), 'idk %s %s' % (result2, rulelst2_order)

    result2.append(rule2)

    old_ind = [r.index for r in rulelst2 if calcNumDifBetweenRulesOutOf3(Rule(rule2, -1), r)==0 and r.index not in rulelst2_order]
    assert(len(old_ind) > 0), "rule 2: %s\nrulelst2: %s" % (rule2, rulelst2)
    rulelst2_order.append(old_ind[0]) # even if old_ind len>1


def finish(rulelst1, rulelst2, delRules, addRules, sharedRules):
    # need to preserve the order of the sharedRulesKeys for BOTH programs based on where they appear in rulelst1
    # but also make sure that the modified rule pairs are added in the same order
    # (even if they don't end up aligned to each other in the same row at the bottom)
    sharedRulesKeys = sorted(list(sharedRules.keys()),
                             key=lambda k: rulelst1.index(sharedRules[k]))
    
    # list of each rule's orig index in rulelst2 (rulelst1's order doesn't change)
    # i.e. index 0 is where a rule will be returned at, but rulelst2_order[0] is where it originally was in the input
    # ^ orig plan, but first need tuples of (new_ind, orig_ind)
    rulelst2_order = []

    result1 = []
    result2 = []
    shared_i = 0
    for i in range(max([len(rulelst1), len(rulelst2)])):
        if i in delRules:
            result1.append(delRules[i].rule)
            if 'pairingCode' in delRules[i].rule:  # i.e. it's del-mod
                rule2 = findPairedRule(
                    addRules, delRules[i].rule['pairingCode']).rule
                addToRulelst2Order(result2, rulelst2_order, rulelst2, rule2)
        # by this point any add-mod should already been added, so below is only the completely + rules
        if i in addRules and 'pairingCode' not in addRules[i].rule:
            rule2 = addRules[i].rule
            addToRulelst2Order(result2, rulelst2_order, rulelst2, rule2)
        if i in sharedRules.keys() and sharedRules != {}:
            result1.append(sharedRules[sharedRulesKeys[shared_i]].rule)
            rule2 = sharedRules[sharedRulesKeys[shared_i]].rule
            addToRulelst2Order(result2, rulelst2_order, rulelst2, rule2)
            shared_i += 1

    assert(len(set(rulelst1))==(len(delRules)+len(sharedRules))), "%d != %d+%d" % (len(set(rulelst1)), len(delRules), len(sharedRules))
    assert(len(set(rulelst2))==(len(addRules)+len(sharedRules))), "%d != %d+%d" % (len(set(rulelst2)), len(addRules), len(sharedRules))
    assert(len(result1)==len(set(rulelst1)))
    assert(len(result2)==len(set(rulelst2)))
    assert(len(set(rulelst2))==len(rulelst2_order))
    return [result1, result2, rulelst2_order]


def compare_rules_text(rule_set_ver_1, rule_set_ver_2, keep_ver_1_order=True):
    ''' Given two rulesets, compare them and return them with status codes attached to each clause/rule, indicating whether it was del/add/mod.'''
    rulelst1 = [Rule(rule_set_ver_1[i], i) for i in range(len(rule_set_ver_1))]
    rulelst2 = [Rule(rule_set_ver_2[i], i) for i in range(len(rule_set_ver_2))]
    ruleset1, ruleset2 = set(rulelst1), set(rulelst2)

    # find out which rules are shared and which ones are not
    delRules = {r.index: r for r in list(ruleset1-ruleset2)}
    addRules = {r.index: r for r in list(ruleset2-ruleset1)}
    sharedRules = {r.index: r for r in list(ruleset1 & ruleset2)}

    for rule in sharedRules.values():
        rule.setRuleStatus(SHARE_CODE)

    # If this is true, there are no rules that have been partially changed,
    # so let's just set the statuses and return
    if len(delRules) == 0 or len(addRules) == 0:
        for rule in delRules.values():
            rule.setRuleStatus(DEL_CODE)
        for rule in addRules.values():
            rule.setRuleStatus(ADD_CODE)

        [result1, result2, rulelst2_order] = finish(rulelst1,
                                    rulelst2, delRules, addRules, sharedRules)
        return [result1, result2, rulelst2_order]

    # Else, we need to figure out which rules have been partially changed.
    (new_delRules, new_addRules) = findDif(delRules, addRules)

    [result1, result2, rulelst2_order] = finish(rulelst1, rulelst2,
                                new_delRules, new_addRules, sharedRules)
    return [result1, result2, rulelst2_order]
