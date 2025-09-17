# PragmaCrediYa - Microservicios Contenerizados

Este proyecto contiene dos microservicios contenerizados que se comunican entre sí:

- **Autenticación** (puerto 8081): Gestiona usuarios y autenticación
- **Solicitudes** (puerto 8082): Gestiona solicitudes de crédito

## 🚀 Inicio Rápido

### Requisitos Previos
- Docker Desktop instalado
- Docker Compose instalado

### Levantar toda la aplicación
## 🚀 Inicio Rápido

### Requisitos Previos
- Docker Desktop instalado
- Docker Compose instalado
- Los repositorios de microservicios deben estar en directorios adyacentes

### Estructura de directorios esperada
```
Proyectos/
├── pragma-credi-ya-infraestructura/  (este repo)
├── pragma-credi-ya-usuario/
└── pragma-credi-ya-solicitud/
```

### Levantar toda la aplicación

#### Opción 1: Construcción automática
```bash
# Construir imágenes primero (Windows)
.\build-images.ps1

# Construir imágenes primero (Linux/Mac)
chmod +x build-images.sh
./build-images.sh

# Luego levantar los servicios
docker-compose up -d
```

#### Opción 2: Manual
```bash
# Desde el directorio padre
cd ../pragma-credi-ya-usuario
docker build -f deployment/Dockerfile -t pragmacrediya-autenticacion:latest .

cd ../pragma-credi-ya-solicitud
docker build -f deployment/Dockerfile -t pragmacrediya-solicitudes:latest .

cd ../pragma-credi-ya-infraestructura
docker-compose up -d
```

### Comandos útiles

#### Construcción y ejecución
```bash
# Construir y levantar todos los servicios
docker-compose up --build

# Levantar en segundo plano
docker-compose up -d

# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f autenticacion
docker-compose logs -f solicitudes
```

#### Gestión de servicios
```bash
# Parar todos los servicios
docker-compose down

# Parar y eliminar volúmenes (CUIDADO: se pierden los datos)
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart autenticacion

# Reconstruir un servicio específico
docker-compose up --build autenticacion
```

#### Debugging
```bash
# Entrar al contenedor de un microservicio
docker-compose exec autenticacion sh
docker-compose exec solicitudes sh

# Ver el estado de los servicios
docker-compose ps

# Ver el uso de recursos
docker stats
```

## 🌐 Endpoints

### Microservicio de Autenticación
- **Base URL**: http://localhost:8081
- **Health Check**: http://localhost:8081/actuator/health

### Microservicio de Solicitudes
- **Base URL**: http://localhost:8082
- **Health Check**: http://localhost:8082/actuator/health

### Base de Datos (PgAdmin)
- **URL**: http://localhost:5050
- **Email**: admin@pragma.com
- **Password**: admin123

## 🔗 Comunicación entre Microservicios

Los microservicios se comunican usando los nombres de los servicios definidos en Docker Compose:

- Desde Solicitudes → Autenticación: `http://autenticacion:8081`
- Desde Autenticación → Solicitudes: `http://solicitudes:8082`

## 📊 Bases de Datos

### Autenticación
- **Host**: localhost:5433 (desde el host)
- **Host**: db_autenticacion:5432 (desde contenedores)
- **Database**: crediyaseguridad
- **Usuario**: crediya
- **Password**: crediya2025

### Solicitudes
- **Host**: localhost:5434 (desde el host)
- **Host**: db_solicitudes:5432 (desde contenedores)
- **Database**: crediyasolicitud
- **Usuario**: crediya
- **Password**: crediya2025

## 🛠️ Solución de Problemas

### Problema: Los contenedores no se comunican
**Solución**: Verificar que estén en la misma red (`pragma-network`)

### Problema: Error de conexión a base de datos
**Solución**: 
1. Verificar que la base de datos esté levantada: `docker-compose ps`
2. Ver logs de la base de datos: `docker-compose logs db_autenticacion`

### Problema: Puerto ya en uso
**Solución**: Cambiar los puertos en el docker-compose.yml o parar el servicio que esté usando el puerto

### Problema: Aplicación no inicia
**Solución**: 
1. Ver logs: `docker-compose logs [nombre-servicio]`
2. Verificar health checks: `docker-compose ps`

## 📁 Estructura del Proyecto

```
PragmaCrediYa/
|── pragma-credi-ya-infraestructura/
|   ├── docker-compose.yml              # Orquestación de todos los servicios
|   ├── init-scripts/                   # Scripts de inicialización de BD
|   │   ├── init-autenticacion.sql
|       └── init-solicitudes.sql
├── pragma-credi-ya-usuario/        # Microservicio de Autenticación
│   ├── deployment/
│   │   └── Dockerfile
│   └── applications/app-service/src/main/resources/
│       └── application-docker.yaml
└── pragma-credi-ya-solicitud/      # Microservicio de Solicitudes
    ├── deployment/
    │   └── Dockerfile
    └── applications/app-service/src/main/resources/
        └── application-docker.yaml
```

## ✅ Validación de Funcionamiento

1. **Verificar que todos los servicios estén corriendo**:
   ```bash
   docker-compose ps
   ```

2. **Verificar health checks**:
   ```bash
   curl http://localhost:8081/actuator/health
   curl http://localhost:8082/actuator/health
   ```

3. **Verificar comunicación entre microservicios**:
   - Hacer una llamada desde Solicitudes que requiera autenticación
   - Verificar en los logs que la comunicación sea exitosa

¡Tu aplicación está lista para funcionar con un solo comando! 🎉

## Ejecutar de forma manual el proyecto ✅

1.- Verificamos las redes
   ```bash
   $ docker network ls | findstr pragma
   ```

2.- En caso de que esten creadas las redes, pararlas y eliminarlas las imagenes para empezar de cero
   ```bash
   # Para las imagenes en caso esten encendidas
   $ docker stop pragma-autenticacion pragma-solicitudes pragma-db-autenticacion pragma-db-solicitudes pragma-pgadmin

   # Eliminar las imagenes
   $ docker rm pragma-autenticacion pragma-solicitudes pragma-db-autenticacion pragma-db-solicitudes pragma-pgadmin

   # Eliminar las redes
   $ docker network rm pragmacrediya_pragma-network
   ```
3.- Construir imágenes primero (Windows)
   ```bash
   # Crea las imagenes
   $ .\build-images.ps1
   ```

4.- Verficar las imagenes creadas
   ```bash
      $ docker images | findstr pragmacrediya
         resultado:
            pragmacrediya-solicitudes                        latest      060b76cce163   47 minutes ago      416MB
            pragmacrediya-autenticacion                      latest      9841eb160a83   About an hour ago   410MB
   ```  

5.- Levantar los servicios
   ```bash
      $ docker-compose up -d
   ```  

5.- Validar los servicios que este levantados correctamente
   ```bash
      $ docker-compose ps

      # Ejemplo:
      NAME                      IMAGE                                SERVICE            STATUS                             PORTS
pragma-autenticacion      pragmacrediya-autenticacion:latest   autenticacion      Up 31 seconds (healthy)            0.0.0.0:8081->8081/tcp, [::]:8081->8081/tcp
pragma-db-autenticacion   postgres:15-alpine                   db_autenticacion   Up 38 seconds (healthy)            0.0.0.0:5433->5432/tcp, [::]:5433->5432/tcp
pragma-db-solicitudes     postgres:15-alpine                   db_solicitudes     Up 38 seconds (healthy)            0.0.0.0:5434->5432/tcp, [::]:5434->5432/tcp
pragma-pgadmin            dpage/pgadmin4:latest                pgadmin            Up 36 seconds                      0.0.0.0:5050->80/tcp, [::]:5050->80/tcp
pragma-solicitudes        pragmacrediya-solicitudes:latest     solicitudes        Up 13 seconds (health: starting)   0.0.0.0:8082->8082/tcp, [::]:8082->8082/tcp
   ```  