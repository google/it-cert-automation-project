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


# First parameter is the ID, second parameter is the filename
FILEID=$1
FILENAME=$2

# This script downloads the drive file with the given ID and saves it with the given name

COOKIE_FILE=$(mktemp cookiesXXXX.txt)

# First get the confirmation prompt because the file is too big
CONFIRM=$(wget --quiet --save-cookies ${COOKIE_FILE} --keep-session-cookies "https://docs.google.com/uc?export=download&id=${FILEID}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')

# Then download the file using the confirmation prompt
wget --load-cookies ${COOKIE_FILE} "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILEID}" -O ${FILENAME}

# Finally, delete the cookie file
rm ${COOKIE_FILE}
