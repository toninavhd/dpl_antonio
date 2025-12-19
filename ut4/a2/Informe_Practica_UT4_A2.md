<center>

# CONFIGURACIÓN DE POSTGRESQL CON DJANGO

</center>

**_Nombre:_** Antonio Navarro Hernández
**_Curso:_** 2º de Ciclo Superior de Desarrollo de Aplicaciones Web.

### ÍNDICE

- [Introducción](#id1)
- [Objetivos](#id2)
- [Material empleado](#id3)
- [Desarrollo](#id4)
- [Conclusiones](#id5)

#### **_Introducción_**. <a name="id1"></a>

Esta práctica se centra en la configuración de un entorno de desarrollo web completo utilizando Django como framework de desarrollo, PostgreSQL como sistema de gestión de base de datos, y pgAdmin como herramienta de administración de bases de datos. El objetivo principal es migrar un proyecto Django desde SQLite (base de datos por defecto) hacia PostgreSQL, que es la opción recomendada para entornos de producción debido a su mayor robustez, escalabilidad y funcionalidades avanzadas.


#### **_Objetivos_**. <a name="id2"></a>

Los objetivos principales de esta práctica son:

1. **Instalación y configuración de PostgreSQL**: Instalar el servidor de base de datos PostgreSQL en el sistema y realizar la configuración básica.

2. **Instalación de pgAdmin**: Instalar y configurar pgAdmin como herramienta de administración web para PostgreSQL.

3. **Configuración de Django para PostgreSQL**: Modificar la configuración de Django para utilizar PostgreSQL como base de datos en lugar de SQLite.

4. **Gestión de bases de datos**: Crear una nueva base de datos, un usuario con permisos adecuados y configurar las conexiones.

5. **Migración de datos**: Realizar las migraciones necesarias para crear la estructura de la base de datos en PostgreSQL.

6. **Verificación del funcionamiento**: Comprobar que la aplicación Django funciona correctamente con la nueva configuración de base de datos.

#### **_Material empleado_**. <a name="id3"></a>

**Hardware:**

- Sistema operativo Linux (Ubuntu/Debian)
- Equipo de desarrollo con conexión a internet

**Software:**

- **Sistema operativo**: Linux con interfaz de línea de comandos
- **Python**: Intérprete de Python 3.x (ya instalado en el sistema)
- **Django**: Framework web de Python (versión 6.0)
- **PostgreSQL**: Sistema de gestión de base de datos relacional
- **pgAdmin**: Herramienta de administración web para PostgreSQL
- **Gunicorn**: Servidor WSGI para Python
- **Terminal**: Para ejecutar comandos de instalación y configuración

**Configuraciones realizadas:**

- Instalación de dependencias de desarrollo (curl, apt-transport-https)
- Configuración de PostgreSQL con usuario y base de datos
- Configuración de Django para conectar con PostgreSQL
- Configuración de servicios del sistema

#### **_Desarrollo_**. <a name="id4"></a>

**Paso 1: Instalación de PHP y dependencias**

Comenzamos instalando PHP y sus dependencias necesarias para el desarrollo web. Esto incluye la configuración de repositorios APT y la instalación de paquetes adicionales.

![Instalación PHP](img/ut4/1-instalarphp.png)

_Figura 1: Proceso de instalación de PHP. Se muestra la actualización del sistema tras la instalación de PHP y la instalación de paquetes adicionales como curl y apt-transport-https._

Después de la instalación de PHP, realizamos una actualización del sistema para asegurar que todos los paquetes estén actualizados:

![Actualización sistema](img/ut4/2-updatetras_instalarphp.png)

_Figura 2: Actualización del sistema tras la instalación de PHP. Se ejecutan comandos de actualización para asegurar que todos los paquetes estén en su última versión._

**Paso 2: Instalación de dependencias adicionales**

Instalamos curl y apt-transport-https, que son necesarios para la gestión de repositorios HTTPS y transferencia de datos:

![Instalación dependencias](img/ut4/3-apt-transport.png)

_Figura 3: Instalación de curl y apt-transport-https. Estos paquetes son esenciales para gestionar repositorios seguros y transferencias de datos._

**Paso 3: Instalación de curl**

Instalamos curl como herramienta adicional para transferencias de datos:

![Instalación curl](img/ut4/4-curl.png)

_Figura 4: Instalación de curl, herramienta de línea de comandos para transferencias de datos con various protocolos._

**Paso 4: Instalación de PostgreSQL**

Procedemos con la instalación de PostgreSQL, que será nuestro sistema de gestión de base de datos:

![Instalación PostgreSQL](img/ut4/5install-postgres.png)

_Figura 5: Proceso de instalación de PostgreSQL. Se instala el servidor de base de datos PostgreSQL junto con sus dependencias y herramientas asociadas._

**Paso 5: Verificación de versiones**

Verificamos las versiones instaladas de los componentes principales:

![Verificación versiones](img/ut4/6-version.png)

_Figura 6: Comandos para verificar las versiones de PHP y PostgreSQL instalados en el sistema. Se confirma que las instalaciones se realizaron correctamente._

**Paso 6: Verificación de servicios de red**

Comprobamos que PostgreSQL esté escuchando en el puerto adecuado (por defecto el 5432):

![Verificación red](img/ut4/7-netstat.png)

_Figura 7: Uso de netstat para verificar que PostgreSQL esté escuchando en el puerto 5432. Se confirma que el servicio está activo y accesible._

**Paso 7: Creación de base de datos**

Accedemos a PostgreSQL para crear la base de datos de nuestro proyecto:

![Creación base de datos](img/ut4/8-crear-tabla-places.png)

_Figura 8: Creación de la base de datos 'places' en PostgreSQL. Se muestra el acceso a la consola de PostgreSQL y la ejecución del comando CREATE DATABASE._

**Paso 8: Configuración de delimitadores**

Configuramos los delimitadores en PostgreSQL para procedimientos almacenados:

![Configuración delimitadores](img/ut4/9-delimmiter.png)

_Figura 9: Configuración del delimitador en PostgreSQL. Se establece el delimitador $$ para procedimientos almacenados._

**Paso 9: Creación de entorno virtual Python**

Creamos un entorno virtual para nuestro proyecto Django:

![Entorno virtual](img/ut4/10_venv.png)

_Figura 10: Creación y activación de un entorno virtual Python. Se instala Django y se configuran las dependencias del proyecto._

**Paso 10: Instalación de pgAdmin**

Instalamos pgAdmin como herramienta de administración web:

![Instalación pgAdmin](img/ut4/11-pgadmin.png)

_Figura 11: Proceso de instalación de pgAdmin. Se agregan los repositorios necesarios y se instala la interfaz de administración web para PostgreSQL._

**Paso 11: Verificación de pgAdmin instalado**

Confirmamos que pgAdmin se instaló correctamente:

![pgAdmin instalado](img/ut4/12-pgadmin_instalado.png)

_Figura 12: Verificación de la instalación de pgAdmin. Se confirma que el paquete se instaló correctamente en el sistema._

**Paso 12: Instalación de Gunicorn**

Instalamos Gunicorn como servidor WSGI para producción:

![Instalación Gunicorn](img/ut4/13-gunicorn.png)

_Figura 13: Instalación de Gunicorn, el servidor WSGI para Python que utilizaremos para servir la aplicación Django en producción._

**Paso 13: Activación de servicio pgAdmin**

Configuramos y activamos el servicio de pgAdmin:

![Activación servicio](img/ut4/14-activar_servicio_pgadmin.png)

_Figura 14: Activación del servicio de pgAdmin. Se habilita el servicio para que se inicie automáticamente con el sistema._

**Paso 14: Verificación del servicio activo**

Comprobamos que el servicio de pgAdmin esté funcionando correctamente:

![Servicio activo](img/ut4/15-pgadminactive.png)

_Figura 15: Verificación del estado del servicio pgAdmin. Se confirma que el servicio está activo y funcionando correctamente._

**Configuración final de Django**

El proyecto Django se configuró para utilizar PostgreSQL modificando el archivo `settings.py`:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'travelroad',
        'USER': 'travelroad_user',
        'PASSWORD': 'dpl0000',
        'HOST': 'localhost',
        'PORT': 5432,
    }
}
```

Se utilizó la librería `prettyconf` para la configuración externa:

```python
from prettyconf import config

DEBUG = config('DEBUG', default=True, cast=config.boolean)
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default=[], cast=config.list)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME', default='travelroad'),
        'USER': config('DB_USERNAME', default='travelroad_user'),
        'PASSWORD': config('DB_PASSWORD', default='dpl0000'),
        'HOST': config('DB_HOST', default='localhost'),
        'PORT': config('DB_PORT', default=5432, cast=int),
    }
}
```

#### **_Conclusiones_**. <a name="id5"></a>

La configuración de PostgreSQL con Django ha sido completada exitosamente, logrando establecer un entorno de desarrollo robusto y escalable. Los principales logros de esta práctica incluyen:

**Aspectos técnicos logrados:**

- **Instalación completa del stack**: Se instaló exitosamente PostgreSQL, pgAdmin, Django y las dependencias necesarias.
- **Configuración de base de datos**: Se creó una base de datos funcional con usuario y permisos adecuados.
- **Configuración externa**: Se implementó el uso de `prettyconf` para gestionar la configuración de forma externa, mejorando la seguridad y flexibilidad del despliegue.
- **Verificación de servicios**: Todos los servicios (PostgreSQL, pgAdmin) están activos y funcionando correctamente.

**Beneficios obtenidos:**

- **Escalabilidad**: PostgreSQL ofrece mejor rendimiento que SQLite para aplicaciones con múltiples usuarios concurrentes.
- **Administración**: pgAdmin proporciona una interfaz gráfica intuitiva para gestionar la base de datos.
- **Configuración flexible**: El uso de variables de entorno facilita el despliegue en diferentes entornos (desarrollo, testing, producción).
- **Buenas prácticas**: Se establecieron las bases para un entorno de producción profesional.

**Lecciones aprendidas:**

- La importancia de verificar cada paso de la instalación para detectar errores tempranamente.
- La necesidad de configurar correctamente los servicios del sistema para un funcionamiento automático.
- El valor de utilizar herramientas de administración como pgAdmin para simplificar la gestión de bases de datos.

Esta configuración establece una base sólida para el desarrollo de aplicaciones web con Django y PostgreSQL, proporcionando un entorno profesional y escalable que puede evolucionar hacia un entorno de producción completo.
