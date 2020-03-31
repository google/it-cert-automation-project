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


# This setup script sets up the project as it starts in the exercise.
# It's recommended to run this on a separate VM.

# Packages that need to be installed (tested on a Debian 9 VM)
sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
	python3-django python3-djangorestframework 

# Files are taken from this dir
ORIGIN_DIR=~
DATA_DIR=/var/www/data

# Copy feedback files
sudo mkdir -p ${DATA_DIR}/feedback
sudo cp ${ORIGIN_DIR}/feedback/* ${DATA_DIR}/feedback

# Setup Django and the project
PROJECT_DIR=/var/www/projects
PROJECT_NAME=corpweb
APP_NAME=feedback

sudo mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}
sudo django-admin startproject ${PROJECT_NAME}
cd ${PROJECT_NAME}
sudo python3 manage.py startapp ${APP_NAME}

sudo cp ${ORIGIN_DIR}/app-files/settings.py ${PROJECT_NAME}/settings.py
sudo cp ${ORIGIN_DIR}/app-files/urls.py ${PROJECT_NAME}/urls.py

sudo cp ${ORIGIN_DIR}/app-files/models.py ${APP_NAME}/models.py
sudo cp ${ORIGIN_DIR}/app-files/serializers.py ${APP_NAME}/serializers.py
sudo cp ${ORIGIN_DIR}/app-files/views.py ${APP_NAME}/views.py

sudo mkdir ${APP_NAME}/templates
sudo cp ${ORIGIN_DIR}/app-files/feedback_index.html ${APP_NAME}/templates/feedback_index.html

sudo python3 manage.py makemigrations ${APP_NAME}
sudo python3 manage.py migrate

sudo cp ${ORIGIN_DIR}/app-files/corpweb.service /etc/systemd/system/corpweb.service
sudo systemctl start ${PROJECT_NAME}

