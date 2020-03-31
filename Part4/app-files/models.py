from django.db import models

class Fruits(models.Model):
   created = models.DateTimeField(auto_now_add=True)
   name = models.CharField(max_length=100, blank=True, default='')
   weight = models.IntegerField()
   description = models.CharField(max_length=5000, default='')
   image_name = models.CharField(max_length=100, blank=True, default='')

   class Meta:
      ordering = ['created']


class Image(models.Model):
    image = models.ImageField(upload_to='images/', blank=True)

    def __str__(self):
        return self.image.name
