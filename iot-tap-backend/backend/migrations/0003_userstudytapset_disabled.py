# Generated by Django 2.0.2 on 2020-05-20 20:50

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0002_auto_20200329_2100'),
    ]

    operations = [
        migrations.AddField(
            model_name='userstudytapset',
            name='disabled',
            field=models.BooleanField(default=False),
        ),
    ]