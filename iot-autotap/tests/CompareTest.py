"""
Copyright 2017-2019 Lefan Zhang

This file is part of AutoTap.

AutoTap is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AutoTap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AutoTap.  If not, see <https://www.gnu.org/licenses/>.
"""


from autotapmc.analyze.Analyze import compareRules
from autotapmc.model.Tap import Tap
# import autotapmc.channels.template.Evaluation as TemplateDict
from autotapmc.channels.template.DbTemplate import template_dict

# template_dict = TemplateDict.__dict__
# change trigger event 1a not revert
# tap_list_buggy = [Tap('window_liv.open=false', 'window_liv.open=true', ['weather.raining=true']),
#                   Tap('window_liv.open=false', 'weather.raining=false', ['window_liv.open=true'])]

tap_list_correct = [
        Tap(trigger='hue_lights.light_color_color=Red', condition=[], action='roomba.power_onoff_setting=true'),
        Tap(trigger='clock.is_it_daytime_time=true', condition=[], action='smart_tv.power_onoff_setting=true'),
        Tap(trigger='fitbit.sleep_sensor_status=true', condition=[], action='bedroom_window.lockunlock_setting=true')
    ]
tap_list_buggy = [
        Tap(trigger='hue_lights.light_color_color=Red', condition=[], action='smart_tv.power_onoff_setting=false'),
        Tap(trigger='clock.is_it_daytime_time=true', condition=[], action='thermostat.ac_onoff_setting=false'),
        Tap(trigger='fitbit.sleep_sensor_status=true', condition=[], action='front_door_lock.lockunlock_setting=false'),
        Tap(trigger='smoke_detector.smoke_detection_condition=true', condition=[], action='smart_tv.power_onoff_setting=false')
    ]
result = compareRules(tap_list_correct, tap_list_buggy, template_dict)
result = [str(r) for r in result]
result = '\n'.join(result)
print(result)
