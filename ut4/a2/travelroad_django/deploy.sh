#!/bin/bash

# Directorio del proyecto en el servidor remoto
REMOTE_DIR="/home/toni/Documentos/dpl_antonio/ut4/a2/travelroad_django"

ssh arkania "
  cd $REMOTE_DIR
  git pull

  source .venv/bin/activate
  pip install -r requirements.txt

  # python manage.py migrate
  # python manage.py collectstatic --no-input

  supervisorctl restart travelroad
"

