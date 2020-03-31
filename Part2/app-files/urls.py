from django.conf.urls import url
from django.contrib import admin
from feedback import views

urlpatterns = [
    url(r'^feedback/', views.feedback_list),
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.feedback_index),
]

