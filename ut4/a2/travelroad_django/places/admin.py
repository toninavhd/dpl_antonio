from django.contrib import admin
from .models import Place

@admin.register(Place)
class PlaceAdmin(admin.ModelAdmin):
    list_display = ('name', 'visited')
    list_filter = ('visited',)
    search_fields = ('name',)

