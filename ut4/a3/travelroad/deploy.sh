#!/bin/bash

ssh arkania "
  cd $(dirname $0)
  git pull
  composer install

  php artisan migrate
"
