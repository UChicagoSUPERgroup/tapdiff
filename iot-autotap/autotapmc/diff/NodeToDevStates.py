import re, operator

###################################
#### Translate nodes to states ####
###################################

OPS = {">": operator.gt, "<": operator.lt, ">=": operator.ge,
           "<=": operator.le, "=": operator.eq, "!=": operator.ne}

def getDevType(param, template_dict):
    ''' Returns "bool", "set", or "numeric" '''
    (dev_name, cap) = param.split('.')
    assert(dev_name in template_dict and cap in template_dict[dev_name]), 'not found in template_dict: %s' % param
    dev_info = template_dict[dev_name][cap].split(', ')
    dev_ext = 1 if ((len(dev_info)>1) and (dev_info[1]=='external')) else 0
    dev_type = dev_info[0]
    return (dev_type, dev_ext)

def getParts(s):
    ''' Should've just used regex :/'''
    if '>=' in s:
        l = '>='
    elif '<=' in s:
        l = '<='
    elif '>' in s:
        l = '>'
    elif '<' in s:
        l = '<'
    else:
        l = '='
    return (s.split(l)[0], l, s.split(l)[1])

def getIntVars(caps, template_dict):
    ''' caps = ['x.x=true', ...]'''
    int_vars = [v for v in caps if getDevType(v.split('=')[0], template_dict)[1]==0]
    return int_vars

def getExtVars(caps, template_dict):
    ''' caps = ['x.x=true', ...]'''
    ext_vars = [v for v in caps if getDevType(v.split('=')[0], template_dict)[1]==1]
    return ext_vars