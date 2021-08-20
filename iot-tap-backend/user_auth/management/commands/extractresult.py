from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
import backend.models as m
from autotap.views import diff_helper, qdiff_helper, spdiff_helper
from backend.views import fe_compare_rules_helper
from backend.utils import updateCachedData

import csv
import sys


class Command(BaseCommand):
    def handle(self, *args, **options):
        csv_writer = csv.writer(sys.stdout, lineterminator='\n')
        title_row = ['code', 'task', 'condition', 'time', 'selection']
        csv_writer.writerow(title_row)

        user_selections = m.UserSelection.objects.all()
        for user_selection in user_selections:
            user = user_selection.owner
            task = user_selection.task
            time = user_selection.time_elapsed
            selection = user_selection.selection
            rule_metas = m.ESRuleMeta.objects.filter(rule__owner=user, rule__task=task)
            try:
                rule_meta = list(rule_metas)[0]
                condition = rule_meta.tapset.condition
            except IndexError:
                # didn't find meta
                condition = 'unknown'
            row = [user.code, task, condition, time, selection]
            csv_writer.writerow(row)


# @csrf_exempt
# def update_data_file(request):
#     task1_list = ['7404506', '4160076', '1672002', '4603843', '5725646']
#     task2_list = ['4000777', '9559065', '6579203', '7746729']
#     task_list = task1_list + task2_list

#     inputfile = '09_30_19-numeric.csv'
#     outputfile = 'new.csv'
#     with open(inputfile, 'r', encoding="utf8") as input_fp, open(outputfile, 'w+', encoding="utf8") as output_fp:
#         csv_data = csv.reader(input_fp, delimiter=',')
#         csv_writer = csv.writer(output_fp)
#         row_num = 1
#         prolific_id_col = -1
#         for row in csv_data:
#             if row_num == 1:
#                 row = list(row)
#                 prolific_id_col = row.index('PROLIFIC_PID')
#                 for task in task1_list:
#                     row.append('task %s choice' % task)
#                     row.append('task %s time (ms)' % task)
#                     row.append('task %s correct' % task)
#                 for task in task2_list:
#                     row.append('task %s choice' % task)
#                     row.append('task %s time (ms)' % task)
#                     row.append('task %s condition' % task)
#                     row.append('task %s correct' % task)
#                 csv_writer.writerow(row)
#                 row_num = row_num + 1
#             elif row_num <= 3:
#                 csv_writer.writerow(row)
#                 row_num = row_num + 1
#             else:
#                 row = list(row)
#                 pid = row[prolific_id_col]
#                 for task in task1_list:
#                     try:
#                         user_sel = m.UserSelection.objects.get(owner__code=pid, task=task)
#                         sel = user_sel.selection
#                         time_elapsed = user_sel.time_elapsed
#                         is_correct = '1' if sel == task1_correct_answer[task] else '0'
#                         row.append(str(sel))
#                         row.append(time_elapsed)
#                         row.append(is_correct)
#                     except m.UserSelection.DoesNotExist:
#                         row.append('')
#                         row.append('')
#                         row.append('')
#                 for task in task2_list:
#                     try:
#                         user_sel = m.UserSelection.objects.get(owner__code=pid, task=task)
#                         rulemeta_list = list(m.ESRuleMeta.objects.filter(rule__owner__code=pid, rule__task=int(task)))
#                         sel = user_sel.selection
#                         time_elapsed = user_sel.time_elapsed
#                         condition = rulemeta_list[0].tapset.condition
#                         is_correct = '1' if sel == task2_correct_answer[str(condition)] else '0'
#                         row.append(str(sel))
#                         row.append(time_elapsed)
#                         row.append(condition)
#                         row.append(is_correct)
#                     except (m.UserSelection.DoesNotExist, m.ESRuleMeta.DoesNotExist, IndexError) as e:
#                         print('owner: ' + str(pid) + ' task: ' + task)
#                         print(e)
#                         row.append('')
#                         row.append('')
#                         row.append('')
#                         row.append('')
#                 csv_writer.writerow(row)
#                 print(pid)

#     return JsonResponse({})
                