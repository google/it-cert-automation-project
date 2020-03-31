from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view, renderer_classes
from rest_framework.renderers import BrowsableAPIRenderer, JSONRenderer
from rest_framework.response import Response
from feedback.models import Feedback
from feedback.serializers import FeedbackSerializer

@api_view(['GET','POST'])
@renderer_classes([JSONRenderer,BrowsableAPIRenderer])
def feedback_list(request, format=None):
    """
    List all feedback or create a new feedback
    """
    if request.method == 'GET':
        feedback = Feedback.objects.all()
        serializer = FeedbackSerializer(feedback, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = FeedbackSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, 
status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

def feedback_index(request):
    feedback = Feedback.objects.all()
    context = { 'feedback': feedback }
    return render(request, 'feedback_index.html', context)
