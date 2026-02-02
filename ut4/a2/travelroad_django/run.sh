#!/bin/bash

cd $(dirname $0)
source .venv/bin/activate

export DEBUG=0
export ALLOWED_HOSTS="travelroad_django.local,localhost,127.0.0.1"

gunicorn -b 127.0.0.1:8001 main.wsgi:application --workers 2 --timeout 60
