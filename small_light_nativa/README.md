

## Estructura de Archivos

```
small_light_nativa/
├── install.sh           # Script de instalación
├── deploy_native.sh     # Script de despliegue y gestión
├── test_native.sh       # Script de pruebas
├── nginx.conf           # Configuración de nginx
├── index.html           # Página principal
├── style.css            # Estilos
├── script.js            # JavaScript del cliente
└── images/              # Imágenes de ejemplo
```

##  Comandos de Gestión

```bash
# Iniciar nginx
sudo ./deploy_native.sh start

# Detener nginx
sudo ./deploy_native.sh stop

# Reiniciar nginx
sudo ./deploy_native.sh restart

# Recargar configuración (sin detener)
sudo ./deploy_native.sh reload

# Ver estado
sudo ./deploy_native.sh status

# Verificar configuración
sudo ./deploy_native.sh test

# Ver logs
sudo ./deploy_native.sh logs

# Corregir permisos
sudo ./deploy_native.sh perm

# Acceder como root
sudo ./deploy_native.sh shell

# Acceder como usuario nginx
sudo ./deploy_native.sh nginx
```

## Verificación

```bash
# Ejecutar tests
sudo ./test_native.sh

# Probar imagen procesada con curl
curl -k -I 'https://images.antonio.me/img/image01.jpg?small=square,200'
```

Debes ver una respuesta con `HTTP/2 200` y `Content-Type: image/jpeg`.

## URLs de la Aplicación

- **Web:** https://images.antonio.me
- **Imagen de prueba:** https://images.antonio.me/img/image01.jpg?small=square,200
- **Redir HTTP → HTTPS:** http://images.antonio.me → https://images.antonio.me

## 🔧 Parámetros de ngx_small_light

La aplicación genera URLs con los siguientes parámetros:

| Parámetro | Descripción | Ejemplo |
|-----------|-------------|---------|
| `small` | Tamaño y formato | `square,300` (300x300 px, cuadrado) |
| `small:extborder` | Ancho del borde | `5` (5 píxeles) |
| `small:extbordercolor` | Color del borde | `#000000` |
| `small:radialblur` | Enfoque radial | `0x0` |
| `small:gaussianblur` | Desenfoque gaussiano | `0x0` |

Ejemplo completo:
```
https://images.antonio.me/img/image01.jpg?small=square,300&small:extborder=5&small:extbordercolor=#000000&small:radialblur=0x0&small:gaussianblur=0x0
```

## Archivos de Log

- **Errores:** `/var/log/nginx/error.log`
- **Accesos:** `/var/log/nginx/access.log`
- **Logs del sistema:** `journalctl -u nginx`

## Solución de Problemas

### El módulo no se carga
```bash
# Verificar que el módulo existe
ls -la /etc/nginx/modules/ngx_http_small_light_module.so

# Verificar configuración
nginx -t

# Ver errores
journalctl -u nginx
```

### Error 403 Forbidden
```bash
# Corregir permisos
sudo ./deploy_native.sh perm

# Reiniciar nginx
sudo ./deploy_native.sh restart
```

### Las imágenes no se procesan
```bash
# Verificar ImageMagick
convert --version

# Probar ImageMagick directamente
convert /var/www/html/img/image01.jpg -resize 100x100 /tmp/test.jpg

# Verificar permisos del directorio temporal
ls -la /tmp/small_light
```

### El puerto 443 no responde
```bash
# Verificar que nginx está escuchando
ss -tln | grep -E ':443|:80'

# Verificar certificado SSL
openssl x509 -in /etc/nginx/ssl/server.crt -text -noout
```

## Acerca del Certificado SSL

El script genera un certificado autofirmado con SAN para `images.antonio.me`. Los navegadores mostrarán una advertencia de seguridad porque no está firmado por una CA reconocida.

Para producción, se recomienda usar Let's Encrypt:
```bash
sudo certbot --nginx -d images.antonio.me
```
