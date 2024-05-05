from django.urls import path
from . import views

urlpatterns = [
	path('', views.NoteListCreateAPIView.as_view()),
	path('<int:pk>/', views.NoteDetailAPIView.as_view()),
	path('<int:pk>/update/', views.NoteUpdateAPIView.as_view()),
	path('<int:pk>/delete/', views.NoteDestroyAPIView.as_view())
]