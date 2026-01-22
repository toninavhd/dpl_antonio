#!/bin/bash

ssh dplprod_antonio@10.102.19.40 "
  set -e
  cd /home/dplprod_antonio/dpl_antonio/ut4/a2/travelroad_django

  git pull

  source .venv/bin/activate
  pip install -r requirements.txt

  #python manage.py migrate

  supervisorctl restart travelroad
"
