from autotapmc.model.Tap import Tap
from autotapmc.diff.SpSynthesize import synthesizeSp
from autotapmc.channels.template.SpBenchmark import template_dict
import json
import time


json_filename = 'benchmarks/diff/7_4_1_compare.json'
with open(json_filename, 'r') as fp:
    benchmark = json.load(fp)

# translate tap format
tap_list_1 = benchmark['tap_list_1']
tap_list_2 = benchmark['tap_list_2']

tap_list = [Tap(trigger=tap['trigger'], action=tap['action'], condition=tap['condition']) for tap in tap_list_1]

t1 = time.time()
synthesizeSp(tap_list, template=template_dict)
t2 = time.time()
print(t2-t1)
