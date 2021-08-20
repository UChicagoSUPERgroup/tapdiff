# Generated by Django 2.0.2 on 2019-08-28 21:09

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='AbstractCharecteristic',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('characteristic_name', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Device',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('device_name', models.CharField(max_length=200)),
                ('users', models.ManyToManyField(to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='DeviceCharecteristic',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('abstract_charecteristic', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='rule_management.AbstractCharecteristic')),
            ],
        ),
        migrations.CreateModel(
            name='Rule',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('rule_name', models.CharField(max_length=200)),
            ],
        ),
        migrations.AddField(
            model_name='devicecharecteristic',
            name='affected_rules',
            field=models.ManyToManyField(to='rule_management.Rule'),
        ),
        migrations.AddField(
            model_name='devicecharecteristic',
            name='device',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='rule_management.Device'),
        ),
    ]
