from django.db import models

class Note(models.Model):
	id = models.AutoField(primary_key=True)
	note = models.CharField(max_length=1000)

	def __str__(self):
		return self.note
