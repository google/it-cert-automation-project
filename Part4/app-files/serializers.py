from rest_framework import serializers
from fruits.models import Fruits, Image

class FruitsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Fruits
        fields = ['id', 'name', 'weight', 'description', 'image_name']

class FruitImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Image
        fields = ['image']
