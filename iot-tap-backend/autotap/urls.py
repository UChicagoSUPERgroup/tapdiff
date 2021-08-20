from django.urls import path

from . import views

urlpatterns = [
    path('diff/', views.diff, name='diff'),
    path('qdiff/', views.qdiff, name='qdiff'),
    path('spdiff/', views.spdiff, name='spdiff')
]
