from django.contrib import admin
from django.urls import path
from django.urls import include, path

from . import views

app_name = 'places'

urlpatterns = [
    path('', views.index, name='index'),
    path('', include('places.urls', 'places')),
]