from django.contrib import admin
from django.urls import path
from api import views

urlpatterns = [
    path("", views.qlub, name="qlub"),
    path("admin/", admin.site.urls),
]
