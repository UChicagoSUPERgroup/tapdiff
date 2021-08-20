from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
import backend.models as m
from autotap.views import diff_helper, qdiff_helper, spdiff_helper
from backend.views import fe_compare_rules_helper
from backend.utils import updateCachedData


class Command(BaseCommand):
    def handle(self, *args, **options):
        username = "user"
        template_user = m.User.objects.get(code=username, mode="rules")
        
        # The tasks to be cached
        task_1_list = [2,4,7,8,12, 881, 885, 887, 889]
        task_2_list = [1,3,9]

        # Clear all tapset and rulemeta
        # for tapset in m.UserStudyTapSet.objects.all():
        #     if tapset.task_id in task_1_list or tapset.task_id in task_2_list:
        #         # delete
        #         tapset.delete()

        for task in task_1_list:
            taskset = 1
            scenario = task
            condition = 1
            task_id = task

            try:
                tapset = m.UserStudyTapSet.objects.get(taskset=taskset, scenario=scenario, 
                                                       condition=condition, task_id=task_id)
            except m.UserStudyTapSet.DoesNotExist:
                tapset = m.UserStudyTapSet.objects.create(taskset=taskset, scenario=scenario, 
                                                          condition=condition, task_id=task_id)
            
            rules = m.Rule.objects.filter(owner=template_user, task=task)
            for rule in rules:
                # make it template, create rulemeta
                try:
                    rulemeta = m.ESRuleMeta.objects.get(rule=rule.esrule)
                except m.ESRuleMeta.DoesNotExist:
                    rulemeta = m.ESRuleMeta.objects.create(rule=rule.esrule, tapset=tapset, is_template=True)

        for task in task_2_list:
            taskset = 2
            scenario = task
            task_id = task

            try:
                tapset1 = m.UserStudyTapSet.objects.get(taskset=taskset, scenario=scenario, 
                                                        condition=1, task_id=task_id)
            except m.UserStudyTapSet.DoesNotExist:
                tapset1 = m.UserStudyTapSet.objects.create(taskset=taskset, scenario=scenario, 
                                                           condition=1, task_id=task_id)
            
            try:
                tapset2 = m.UserStudyTapSet.objects.get(taskset=taskset, scenario=scenario, 
                                                        condition=2, task_id=task_id)
            except m.UserStudyTapSet.DoesNotExist:
                tapset2 = m.UserStudyTapSet.objects.create(taskset=taskset, scenario=scenario, 
                                                           condition=2, task_id=task_id)

            rules = m.Rule.objects.filter(owner=template_user, task=task)
            for rule in rules:
                if rule.version == 0:
                    # should be in both cond1 and cond2
                    try:
                        rulemeta1 = m.ESRuleMeta.objects.get(rule=rule.esrule, tapset=tapset1)
                    except m.ESRuleMeta.DoesNotExist:
                        rulemeta1 = m.ESRuleMeta.objects.create(rule=rule.esrule, tapset=tapset1, is_template=True)
                    try:
                        rulemeta2 = m.ESRuleMeta.objects.get(rule=rule.esrule, tapset=tapset2)
                    except m.ESRuleMeta.DoesNotExist:
                        rulemeta2 = m.ESRuleMeta.objects.create(rule=rule.esrule, tapset=tapset2, is_template=True)
                else:
                    tapset_list = [tapset1, tapset2]
                    try:
                        rulemeta = m.ESRuleMeta.objects.get(rule=rule.esrule, tapset=tapset_list[rule.version-1])
                    except m.ESRuleMeta.DoesNotExist:
                        rulemeta = m.ESRuleMeta.objects.create(rule=rule.esrule, tapset=tapset_list[rule.version-1], is_template=True)

