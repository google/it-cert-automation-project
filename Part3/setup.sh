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


# This setup script leaves the machine ready to be used like in the exercise.
# It's strongly recommended that you run this on a VM and not on your local
# machine.

# Preseed the necessary postfix and roundcube settings.
sudo debconf-set-selections << EOF
postfix postfix/mailname        string  example.com
postfix postfix/main_mailer_type        select  Local only
roundcube-core  roundcube/dbconfig-install      boolean true
roundcube-core  roundcube/dbconfig-upgrade      boolean true
EOF

# Install the necessary packages (tested on a Debian 9 VM)
sudo DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  postfix dovecot-core dovecot-imapd \
  roundcube-core roundcube-sqlite3 apache2 \
  python3-reportlab

# Configure Apache to run roundcube
sudo tee /etc/apache2/sites-available/roundcube.conf <<EOF
<VirtualHost *:80>
ServerName webmail.example.com
DocumentRoot /var/lib/roundcube

Include /etc/roundcube/apache.conf
</VirtualHost>
EOF

# Configure roundcube
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

# Start the roundcube site
sudo a2dissite 000-default
sudo a2ensite roundcube
sudo systemctl reload apache2
