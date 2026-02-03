#!/bin/bash
# Script de despliegue automático
ssh dplprod_antonio@10.102.19.40 "
cd dpl_antonio
git pull 
echo "Despliegue finalizado con éxito."
"
