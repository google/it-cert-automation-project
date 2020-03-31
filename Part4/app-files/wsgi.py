#!/usr/bin/env python3

import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "fruitstore.settings")

application = get_wsgi_application()
