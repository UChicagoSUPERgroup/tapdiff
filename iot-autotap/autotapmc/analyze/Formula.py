def splitSimpleFormula(formula):
    if '<=' in formula:
        comp = '<='
        cap, val = formula.split('<=')
    elif '>=' in formula:
        comp = '>='
        cap, val = formula.split('>=')
    elif '!=' in formula:
        comp = '!='
        cap, val = formula.split('!=')
    elif '>' in formula:
        comp = '>'
        cap, val = formula.split('>')
    elif '<' in formula:
        comp = '<'
        cap, val = formula.split('<')
    else:
        comp = '='
        cap, val = formula.split('=')
    
    return cap, comp, val


def checkEventAgainstTrigger(event, trigger):

    trigger_cap, trigger_comp, trigger_val = splitSimpleFormula(trigger)
    event_cap, event_comp, event_val = splitSimpleFormula(event)
    
    if trigger_cap != event_cap:
        return False

    if trigger_comp == '<=':
        return float(event_val) <= float(trigger_val)
    elif trigger_comp == '>=':
        return float(event_val) >= float(trigger_val)
    elif trigger_comp == '<':
        return float(event_val) < float(trigger_val)
    elif trigger_comp == '>':
        return float(event_val) > float(trigger_val)
    elif trigger_comp == '!=':
        return event_val != trigger_val
    else:
        return event_val == trigger_val


def checkValueAgainstCondition(value, condition):
    # this doesn't check if var is correct
    _, comp, cond_val = splitSimpleFormula(condition)

    if comp == '<=':
        return float(value) <= float(cond_val)
    elif comp == '>=':
        return float(value) >= float(cond_val)
    elif comp == '<':
        return float(value) < float(cond_val)
    elif comp == '>':
        return float(value) > float(cond_val)
    elif comp == '!=':
        return str(value).lower() != str(cond_val).lower()
    else:
        return str(value).lower() == str(cond_val).lower()
