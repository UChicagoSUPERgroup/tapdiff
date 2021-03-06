# Generated by Django 2.0.2 on 2019-09-06 16:45

import django.contrib.postgres.fields
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Capability',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=30)),
                ('readable', models.BooleanField(default=True)),
                ('writeable', models.BooleanField(default=True)),
                ('statelabel', models.TextField(max_length=256, null=True)),
                ('commandlabel', models.TextField(max_length=256, null=True)),
                ('eventlabel', models.TextField(max_length=256, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Channel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=30)),
                ('icon', models.TextField(null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Condition',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('val', models.TextField()),
                ('comp', models.TextField(choices=[('=', 'is'), ('!=', 'is not'), ('<', 'is less than'), ('>', 'is greater than')])),
            ],
        ),
        migrations.CreateModel(
            name='Device',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('public', models.BooleanField(default=True)),
                ('name', models.CharField(max_length=32)),
                ('icon', models.TextField(null=True)),
                ('caps', models.ManyToManyField(to='backend.Capability')),
                ('chans', models.ManyToManyField(to='backend.Channel')),
            ],
        ),
        migrations.CreateModel(
            name='ESRuleMeta',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('is_template', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='Parameter',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.TextField()),
                ('type', models.TextField(choices=[('set', 'Set'), ('range', 'Range'), ('bin', 'Binary'), ('color', 'Color'), ('time', 'Time'), ('duration', 'Duration'), ('input', 'Input'), ('meta', 'Meta')])),
            ],
        ),
        migrations.CreateModel(
            name='ParVal',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('val', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='Rule',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('task', models.IntegerField(default=1)),
                ('version', models.IntegerField(default=0)),
                ('lastedit', models.DateTimeField(auto_now=True)),
                ('type', models.CharField(choices=[('es', 'es'), ('ss', 'ss')], max_length=3)),
            ],
        ),
        migrations.CreateModel(
            name='SafetyProp',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('task', models.IntegerField()),
                ('lastedit', models.DateTimeField(auto_now=True)),
                ('type', models.IntegerField(choices=[(1, '1'), (2, '2'), (3, '3')])),
                ('always', models.BooleanField()),
            ],
        ),
        migrations.CreateModel(
            name='SetParamOpt',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('value', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='State',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('action', models.BooleanField()),
                ('text', models.TextField(max_length=128, null=True)),
                ('cap', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Capability')),
                ('chan', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='backend.Channel')),
                ('dev', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Device')),
            ],
        ),
        migrations.CreateModel(
            name='StateLog',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField(auto_now=True)),
                ('is_current', models.BooleanField()),
                ('value', models.TextField()),
                ('cap', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='logcap', to='backend.Capability')),
                ('dev', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='logdev', to='backend.Device')),
            ],
        ),
        migrations.CreateModel(
            name='Trigger',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('pos', models.IntegerField(null=True)),
                ('text', models.TextField(max_length=128, null=True)),
                ('cap', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Capability')),
                ('chan', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='backend.Channel')),
                ('dev', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Device')),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=30, null=True, unique=True)),
                ('code', models.TextField(max_length=128)),
                ('mode', models.CharField(choices=[('rules', 'Rule'), ('sp', 'Safety Property')], max_length=5)),
            ],
        ),
        migrations.CreateModel(
            name='UserSelection',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('task', models.IntegerField()),
                ('selection', django.contrib.postgres.fields.ArrayField(base_field=models.IntegerField(), size=None)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.User')),
            ],
        ),
        migrations.CreateModel(
            name='UserStudyTapSet',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('taskset', models.IntegerField(default=0)),
                ('scenario', models.IntegerField(default=0)),
                ('condition', models.IntegerField(default=0)),
                ('task_id', models.IntegerField(default=0)),
            ],
        ),
        migrations.CreateModel(
            name='BinParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('tval', models.TextField()),
                ('fval', models.TextField()),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='ColorParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('mode', models.TextField(choices=[('rgb', 'RGB'), ('hsv', 'HSV'), ('hex', 'Hex')])),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='DurationParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('comp', models.BooleanField(default=False)),
                ('maxhours', models.IntegerField(default=23, null=True)),
                ('maxmins', models.IntegerField(default=59, null=True)),
                ('maxsecs', models.IntegerField(default=59, null=True)),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='ESRule',
            fields=[
                ('rule_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Rule')),
                ('Etrigger', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='EStriggerE', to='backend.Trigger')),
                ('Striggers', models.ManyToManyField(to='backend.Trigger')),
                ('action', models.ForeignKey(limit_choices_to={'action': True}, on_delete=django.db.models.deletion.CASCADE, related_name='ESactionstate', to='backend.State')),
            ],
            bases=('backend.rule',),
        ),
        migrations.CreateModel(
            name='InputParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('inputtype', models.TextField(choices=[('int', 'Integer'), ('stxt', 'Short Text'), ('ltxt', 'Long Text'), ('trig', 'Trigger')])),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='MetaParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('is_event', models.BooleanField()),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='RangeParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('min', models.IntegerField()),
                ('max', models.IntegerField()),
                ('interval', models.FloatField(default=1.0)),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='SetParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('numopts', models.IntegerField(default=0)),
            ],
            bases=('backend.parameter',),
        ),
        migrations.CreateModel(
            name='SP1',
            fields=[
                ('safetyprop_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.SafetyProp')),
                ('triggers', models.ManyToManyField(to='backend.Trigger')),
            ],
            bases=('backend.safetyprop',),
        ),
        migrations.CreateModel(
            name='SP2',
            fields=[
                ('safetyprop_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.SafetyProp')),
                ('comp', models.TextField(choices=[('=', '='), ('!=', '!='), ('>', '>'), ('<', '<')], null=True)),
                ('time', models.IntegerField(null=True)),
                ('conds', models.ManyToManyField(related_name='sp2_conds', to='backend.Trigger')),
                ('state', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sp2_state', to='backend.Trigger')),
            ],
            bases=('backend.safetyprop',),
        ),
        migrations.CreateModel(
            name='SP3',
            fields=[
                ('safetyprop_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.SafetyProp')),
                ('comp', models.TextField(choices=[('=', '='), ('!=', '!='), ('>', '>'), ('<', '<')], null=True)),
                ('occurrences', models.IntegerField(null=True)),
                ('time', models.IntegerField(null=True)),
                ('timecomp', models.TextField(choices=[('=', '='), ('!=', '!='), ('>', '>'), ('<', '<')], null=True)),
                ('conds', models.ManyToManyField(related_name='sp3_conds', to='backend.Trigger')),
                ('event', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sp3_event', to='backend.Trigger')),
            ],
            bases=('backend.safetyprop',),
        ),
        migrations.CreateModel(
            name='SSRule',
            fields=[
                ('rule_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Rule')),
                ('priority', models.IntegerField()),
                ('action', models.ForeignKey(limit_choices_to={'action': True}, on_delete=django.db.models.deletion.CASCADE, related_name='SSactionstate', to='backend.State')),
                ('triggers', models.ManyToManyField(to='backend.Trigger')),
            ],
            bases=('backend.rule',),
        ),
        migrations.CreateModel(
            name='TimeParam',
            fields=[
                ('parameter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Parameter')),
                ('mode', models.TextField(choices=[('24', '24-hour'), ('12', '12-hour')])),
            ],
            bases=('backend.parameter',),
        ),
        migrations.AddField(
            model_name='statelog',
            name='param',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='logparam', to='backend.Parameter'),
        ),
        migrations.AddField(
            model_name='safetyprop',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.User'),
        ),
        migrations.AddField(
            model_name='rule',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.User'),
        ),
        migrations.AddField(
            model_name='parval',
            name='par',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Parameter'),
        ),
        migrations.AddField(
            model_name='parval',
            name='state',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.State'),
        ),
        migrations.AddField(
            model_name='parameter',
            name='cap',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Capability'),
        ),
        migrations.AddField(
            model_name='esrulemeta',
            name='tapset',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.UserStudyTapSet'),
        ),
        migrations.AddField(
            model_name='device',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.User'),
        ),
        migrations.AddField(
            model_name='condition',
            name='par',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Parameter'),
        ),
        migrations.AddField(
            model_name='condition',
            name='trigger',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Trigger'),
        ),
        migrations.AddField(
            model_name='capability',
            name='channels',
            field=models.ManyToManyField(to='backend.Channel'),
        ),
        migrations.AddField(
            model_name='setparamopt',
            name='param',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.SetParam'),
        ),
        migrations.AddField(
            model_name='esrulemeta',
            name='rule',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.ESRule'),
        ),
    ]
