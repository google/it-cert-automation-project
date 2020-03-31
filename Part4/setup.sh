#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This script sets up the machine like at the start of the exercise.  It's
# strongly recommended that you run this on a VM and not on your local machine.

# Preseed postfix and roundcube
sudo debconf-set-selections << EOF
postfix postfix/mailname        string  example.com
postfix postfix/main_mailer_type        select  Local only
roundcube-core  roundcube/dbconfig-install      boolean true
roundcube-core  roundcube/dbconfig-upgrade      boolean true
EOF

# Install all necessary packages (tested on a Debian 9 VM)
sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  postfix dovecot-core dovecot-imapd \
  roundcube-core roundcube-sqlite3 apache2 \
  python3-reportlab \
  python3-django python3-djangorestframework \
  libapache2-mod-wsgi-py3 \
  python3-pillow python3-requests


# Setup Roundcube and Apache
sudo tee /etc/apache2/sites-available/fruitstore.conf <<EOF
<VirtualHost *:80>
ServerName fruitstore.example.com

Alias /webmail /var/lib/roundcube
Include /etc/roundcube/apache.conf

Alias /media/ /var/www/projects/fruitstore/media/
<Directory /var/www/project/fruitstore/media>
    Require all granted
</Directory>

Alias /static/ /var/www/projects/fruitstore/static/
<Directory /var/www/project/fruitstore/static>
    Require all granted
</Directory>

<Directory /var/www/project/fruitstore>
    <Files wsgi.py>
        Require all granted
    </Files>
</Directory>

WSGIDaemonProcess fruitstore python-path=/var/www/projects/fruitstore
WSGIProcessGroup fruitstore
WSGIScriptAlias / /var/www/projects/fruitstore/wsgi.py
</VirtualHost>
EOF

sudo tee /etc/roundcube/config.inc.php <<EOF
<?php
\$config = array();
include_once("/etc/roundcube/debian-db-roundcube.php");
\$config['default_host'] = 'localhost';
\$config['smtp_server'] = 'localhost';
\$config['smtp_port'] = 25;
\$config['smtp_user'] = '';
\$config['smtp_pass'] = '';
\$config['support_url'] = '';
\$config['product_name'] = 'Roundcube Webmail';
\$config['des_key'] = 'jXihy1dckiYzrj2uWW8LUDqt';
\$config['plugins'] = array();
\$config['skin'] = 'larry';
\$config['enable_spellcheck'] = false;
EOF

sudo a2dissite 000-default
sudo a2ensite fruitstore
sudo systemctl reload apache2

# Setup Django and the fruitstore project
PROJECT_DIR=/var/www/projects
DATA_DIR=/var/www/data
PROJECT_NAME=fruitstore
APP_NAME=fruits

# Files are taken from this dir
ORIGIN_DIR=~/app-files

sudo mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}
sudo django-admin startproject ${PROJECT_NAME}
cd ${PROJECT_NAME}
sudo python3 manage.py startapp ${APP_NAME}

sudo cp ${ORIGIN_DIR}/wsgi.py wsgi.py
sudo cp ${ORIGIN_DIR}/settings.py ${PROJECT_NAME}/settings.py
sudo cp ${ORIGIN_DIR}/urls.py ${PROJECT_NAME}/urls.py

sudo cp ${ORIGIN_DIR}/models.py ${APP_NAME}/models.py
sudo cp ${ORIGIN_DIR}/serializers.py ${APP_NAME}/serializers.py
sudo cp ${ORIGIN_DIR}/views.py ${APP_NAME}/views.py

sudo mkdir ${APP_NAME}/templates
sudo cp ${ORIGIN_DIR}/fruits.html ${APP_NAME}/templates/fruits.html

sudo python3 manage.py makemigrations fruits
sudo python3 manage.py migrate
sudo python3 manage.py collectstatic --noinput --ignore jquery

sudo chown -R www-data.www-data ${PROJECT_DIR}

sudo systemctl restart apache2

