from django.shortcuts import render

from rest_framework import generics
from rest_framework.response import Response

from .models import Note
from .serializers import NoteSerializer

class NoteDetailAPIView(generics.RetrieveAPIView):
	queryset = Note.objects.all()
	serializer_class = NoteSerializer

class NoteListCreateAPIView(generics.ListCreateAPIView):
	queryset = Note.objects.all()
	serializer_class = NoteSerializer

class NoteUpdateAPIView(generics.UpdateAPIView):
	queryset = Note.objects.all()
	serializer_class = NoteSerializer
	lookup_field = 'pk'

	def perform_update(self, serializer):
		instance = serializer.save()

class NoteDestroyAPIView(generics.DestroyAPIView):
	queryset = Note.objects.all()
	serializer_class = NoteSerializer
	lookup_field = 'pk'

	def perform_destroy(self, instance):
		super().perform_destroy(instance=instance)
