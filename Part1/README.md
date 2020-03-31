## Part 1: Automate image processing

This exercise lets you practice 

The data needed for solving the exercise is published on 
[Google Drive](https://drive.google.com/open?id=11hg55-dKdHN63yJP20dMLAgPJ5oiTOHF).
You can download it using the `download_drive_file.sh` script, like this:

```
./download_drive_file.sh 11hg55-dKdHN63yJP20dMLAgPJ5oiTOHF images.zip
```

Then extract it like this:

```
unzip images.zip
```

Once you have extracted the images, you'll need to install Pillow and then
write a script that rotates the images, changes the format to JPEG and the
resolution to 128x128
