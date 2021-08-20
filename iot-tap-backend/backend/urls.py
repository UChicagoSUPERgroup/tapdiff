"""backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from . import views as v


urlpatterns = [
    path('backend/admin/',admin.site.urls),
    path('users/get/', v.fe_all_users),
    path('user/tasks/copy/', v.fe_tasks_copy),
    path('user/tasks/get/', v.fe_tasks_get),
    path('user/tasks/delete/', v.fe_tasks_clear),
    path('user/tasks/versions/delete/', v.fe_taskversions_delete),
    path('user/tasks/versions/copy/', v.fe_taskversions_copy),
    path('user/tasks/versions/select/', v.fe_select_version),
    path('user/get/',v.fe_get_user),
    path('user/rules/',v.fe_all_rules),
    path('user/chans/',v.fe_all_chans),
    path('user/chans/devs/',v.fe_devs_with_chan),
    path('user/chans/devs/caps/',v.fe_get_valid_caps),
    path('user/chans/devs/caps/params/',v.fe_get_params),
    path('user/rules/new/',v.fe_create_esrule),
    path('user/rules/delete/',v.fe_delete_rule),
    path('user/rules/get/',v.fe_get_full_rule),
    path('user/get_cookie/', v.fe_get_cookie),
    path('user/compare/', v.fe_compare_rules),
    path('user/get_version_ids/', v.fe_get_version_ids),
    path('user/get_version_programs/', v.fe_get_version_programs),
    path('autotap/', include('autotap.urls'))
    ]
