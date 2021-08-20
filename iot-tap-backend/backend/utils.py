from django.http import JsonResponse
from django.conf import settings
from . import models as m
import json
import random
import os


DATA_CACHE = 'data_cache/'


def getFileName(task, user, ver_1, ver_2, page="textdiff", cond=None):
    textdiff = DATA_CACHE + 'temp.json'

    if str(task) in settings.TASK1_LIST:
        textdiff = DATA_CACHE+'task'+str(task)+'/'+str(ver_1)+'_'+str(ver_2)+'.json'
    elif str(task) in settings.TASK2_LIST: # task 2
        if cond is None:
            esrule = list(m.ESRule.objects.filter(task=task, owner=user))[0]  # assuming we have rules
            rulemeta = m.ESRuleMeta.objects.get(rule=esrule)
            condition = rulemeta.tapset.condition
            cond1s = 'cond' + str(condition)
        else:
            cond1s = 'cond' + str(cond)
        # if ver_1 == 0 and ver_2 == 0:
        #     textdiff = DATA_CACHE + 'task' + str(task)+'/' + str(ver_1)+'_' + str(ver_2) + '.json'
        # else:
        textdiff = DATA_CACHE+'task'+str(task)+'/'+cond1s+'_'+str(ver_1)+'_'+str(ver_2)+'.json'
    print(task, cond)
    return textdiff


def getCachedData(task, user, ver_1, ver_2, page="textdiff", cond=None):
    textdiff = getFileName(task, user, ver_1, ver_2, page, cond=cond)
    
    try:
        with open(textdiff, 'r') as f:
            lst = json.load(f)
            if page in lst:
                lst = lst[page]
            else:
                return None
        json_resp = lst
        json_resp['userid'] = user.id
    except FileNotFoundError:
        return None
    
    return json_resp


def createFile(filename):
    if not os.path.exists(os.path.dirname(filename)):
        try:
            os.makedirs(os.path.dirname(filename))
        except OSError as exc: # Guard against race condition
            raise exc
        with open(filename, 'w') as fp:
            pass


def updateCachedData(data, task, user, ver_1, ver_2, page="textdiff", cond=None):
    print('==== cache data updated for ', task, ver_1, ver_2, page)
    textdiff = getFileName(task, user, ver_1, ver_2, page, cond=cond)
    if page == "timelinediff":
        json_resp = {'diff': data['diff'], 'num_opts': data['num_opts']}
    else:
        json_resp = {'diff': data['diff']}
    try:
        with open(textdiff, 'r') as f:
            lst = json.load(f)
    except FileNotFoundError:
        createFile(textdiff)
        lst = {}
        
    with open(textdiff, 'w+') as f:
        lst[page] = json_resp
        json.dump(lst, f)


def get_or_make_user_init_rules(code, mode, force_cond=0):
    try:
        user = m.User.objects.get(code=code, mode=mode)
        if force_cond:
            user.delete()
            raise m.User.DoesNotExist
    except m.User.DoesNotExist:
        user = m.User.objects.create(code=code, mode=mode)
        taskset_scenario_set = {(tapset.taskset, tapset.scenario) for tapset in m.UserStudyTapSet.objects.all()}
        for taskset, scenario in taskset_scenario_set:
            # randomly select one condition
            if force_cond:
                condition = force_cond
            else:
                condition_set = {tapset.condition for tapset in m.UserStudyTapSet.objects.filter(taskset=taskset, scenario=scenario, disabled=False)}
                condition = random.choice(list(condition_set))
            # create rules for each taskset
            tapset_list = m.UserStudyTapSet.objects.filter(taskset=taskset, scenario=scenario, condition=condition)
            for tapset in tapset_list:
                rule_meta_list = m.ESRuleMeta.objects.filter(tapset=tapset, is_template=True)
                for rule_meta in rule_meta_list:
                    if tapset.condition == 2:
                        # rule with version 2 should be set to 1
                        rule_version = rule_meta.rule.version if rule_meta.rule.version != 2 else 1
                    else:
                        rule_version = rule_meta.rule.version
                    esrule = m.ESRule.objects.create(Etrigger=rule_meta.rule.Etrigger, action=rule_meta.rule.action, owner=user, 
                                                     task=rule_meta.rule.task, version=rule_version, type=rule_meta.rule.type)
                    esrule.Striggers.set(rule_meta.rule.Striggers.all())
                    m.ESRuleMeta.objects.create(rule=esrule, tapset=tapset, is_template=False)
    return user
