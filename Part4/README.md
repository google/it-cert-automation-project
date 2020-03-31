## Part 4: Automate updating catalog information

This exercise puts together all the tools seen in the course.

As usual, you can use the `setup.sh` script to prepare the machine for the
exercise. And as usual, you should do this on a VM, not on your machine. This
script sets up a Django application and a Roundcube webserver in the same
machine, so that your scripts can interact with the webserver and you can
access the emails as well.

The data needed for solving the exercise is published on 
[Google Drive](https://drive.google.com/open?id=1LePo57dJcgzoK4uiI_48S01Etck7w_5f).
You can download it using the `download_drive_file.sh` script, like this:

```
./download_drive_file.sh 1LePo57dJcgzoK4uiI_48S01Etck7w_5f supplier-data.tar.gz
```

Then extract it like this:

```
tar xf supplier-data.tar.gz
```

