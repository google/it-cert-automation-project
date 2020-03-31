from django.conf.urls import url
from django.contrib import admin
from fruits import views

urlpatterns = [
    url(r'^fruits/', views.fruits_list), 
    url(r'^upload/', views.upload_images), 
    url(r'^$', views.fruits_view),
]

