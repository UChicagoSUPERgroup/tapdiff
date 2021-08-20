from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
import backend.models as m
from autotap.views import diff_helper, qdiff_helper, spdiff_helper
from backend.views import fe_compare_rules_helper
from backend.utils import updateCachedData, get_or_make_user_init_rules


class Command(BaseCommand):
    def update_task2(self, task, template_user, cond):
        real_ver_2 = 1

        ver_pairs = [(0, 0), (0, 1), (1, 1)]
        real_ver_pairs = [(0, 0), (0, real_ver_2), (real_ver_2, real_ver_2)]

        for pair, real_pair in zip(ver_pairs, real_ver_pairs):
            v1, v2 = pair
            rv1, rv2 = real_pair

            kwargs = {
                'taskid': task,
                'version1': rv1,
                'version2': rv2,
                'userid': template_user.id,
                'code': template_user.code
            }
            json_resp = diff_helper(kwargs)
            updateCachedData(json_resp, task, template_user, v1, v2, "timelinediff", cond=cond)
            json_resp = spdiff_helper(kwargs)
            updateCachedData(json_resp, task, template_user, v1, v2, "spdiff", cond=cond)
            json_resp = fe_compare_rules_helper(kwargs)
            updateCachedData(json_resp, task, template_user, v1, v2, "textdiff", cond=cond)

        kwargs = {
            'verids': [0, real_ver_2],
            'taskid': task,
            'userid': template_user.id,
            'code': template_user.code
        }
        json_resp = qdiff_helper(kwargs)
        updateCachedData(json_resp, task, template_user, 0, 0, page="questionsdiff", cond=cond)
    
    def update_task1(self, task, template_user, vers=(0, 1, 2)):
        vers = list(vers)
        pairs = []
        for ii in vers:
            for jj in vers:
                pairs.append((ii, jj))
        # pairs = [(0, 0), (0, 1), (0, 2), (1, 1), (1, 2), (2, 1), (2, 2)]
        for ver_1, ver_2 in pairs:
            kwargs = {
                'taskid': task,
                'version1': ver_1,
                'version2': ver_2,
                'userid': template_user.id,
                'code': template_user.code
            }
            json_resp = diff_helper(kwargs)
            updateCachedData(json_resp, task, template_user, ver_1, ver_2, "timelinediff")
            json_resp = spdiff_helper(kwargs)
            updateCachedData(json_resp, task, template_user, ver_1, ver_2, "spdiff")
            json_resp = fe_compare_rules_helper(kwargs)
            updateCachedData(json_resp, task, template_user, ver_1, ver_2, "textdiff")
        
        kwargs = {
            'verids': vers,
            'taskid': task,
            'userid': template_user.id,
            'code': template_user.code
        }
        json_resp = qdiff_helper(kwargs)
        updateCachedData(json_resp, task, template_user, 0, 0, page="questionsdiff")
        
    def handle(self, *args, **options):
        username = "user"
        template_user = m.User.objects.get(code=username, mode="rules")
        
        # The tasks to be cached
        # task_1_list = [2, 4, 12, 885, 887, 889] # 5?
        task_1_list = [12]
        task_1_special_list = [7, 8, 881]
        task_1_special_vers_list = [tuple(range(1, 28)), tuple(range(1, 17)), tuple(range(1,5))]
        task_2_list = [1,3,9]#,6]

        # task_1_list = []
        # task_1_special_list = []
        # task_1_special_vers_list = []
        # task_2_list = [1]

        for task in task_1_list:
            # should cache all combinations
            print('======updating task', task)
            self.update_task1(task, template_user)

        # for task, vers in zip(task_1_special_list, task_1_special_vers_list):
        #     print('======updating task', task)
        #     self.update_task1(task, template_user, vers)

        # for task in task_2_list:
        #     # should compare ver0 vs ver1 as cond1, ver0 vs ver2 and cond2
        #     print('======updating task', task)
        #     usercond1 = get_or_make_user_init_rules('usercond1', 'rules', force_cond=1)
        #     self.update_task2(task, usercond1, 1)
        #     usercond2 = get_or_make_user_init_rules('usercond2', 'rules', force_cond=2)
        #     self.update_task2(task, usercond2, 2)
            





    