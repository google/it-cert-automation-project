from django.shortcuts import render
from rest_framework import status, viewsets, parsers
from rest_framework.decorators import api_view, renderer_classes, parser_classes
from rest_framework.exceptions import ParseError
from rest_framework.parsers import FileUploadParser, MultiPartParser
from rest_framework.renderers import BrowsableAPIRenderer, JSONRenderer
from rest_framework.response import Response
from fruits.models import Fruits, Image
from fruits.serializers import FruitsSerializer, FruitImageSerializer



@api_view(['GET','POST'])
@renderer_classes([JSONRenderer,BrowsableAPIRenderer])
def fruits_list(request, format=None):
    """
    List all fruit or create a new fruits
    """
    if request.method == 'GET':
        fruits = Fruits.objects.all()
        serializer = FruitsSerializer(fruits, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = FruitsSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@renderer_classes([JSONRenderer,BrowsableAPIRenderer])
@parser_classes([MultiPartParser])
def upload_images(request, format=None):
    print(request)
    if 'file' not in request.data:
        raise ParseError("Empty content")

    f = request.data['file']

    Image().image.save(f.name, f, save=True)
    return Response(status=status.HTTP_201_CREATED)


def fruits_view(request):
    fruits = Fruits.objects.all()
    context = {'fruits': fruits}
    return render(request, "fruits.html", context)
