#!/bin/bash
echo "Testing PHP-FPM on port 9000..."

SCRIPT_FILENAME="/home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public/debug.php"
DOCUMENT_ROOT="/home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public"
SCRIPT_NAME="/debug.php"

echo -e "GET $SCRIPT_NAME HTTP/1.1\r\nHost: travelroad\r\n\r\n" | \
REQUEST_METHOD=GET \
SCRIPT_FILENAME="$SCRIPT_FILENAME" \
DOCUMENT_ROOT="$DOCUMENT_ROOT" \
SCRIPT_NAME="$SCRIPT_NAME" \
cgi-fcgi -bind -connect 127.0.0.1:9000 2>&1 | head -20
