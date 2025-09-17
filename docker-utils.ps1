# Script de utilidades para gestionar los microservicios con Docker en PowerShell
# Uso: .\docker-utils.ps1 [comando]

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

$ProjectName = "pragma-credi-ya"
$ComposeFile = "docker-compose.yml"

# Función para mostrar ayuda
function Show-Help {
    Write-Host "=== PragmaCrediYa Docker Utilities ===" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Comandos disponibles:" -ForegroundColor White
    Write-Host ""
    Write-Host "build          " -ForegroundColor Green -NoNewline; Write-Host "- Construir todas las imágenes"
    Write-Host "start          " -ForegroundColor Green -NoNewline; Write-Host "- Iniciar todos los servicios"
    Write-Host "stop           " -ForegroundColor Green -NoNewline; Write-Host "- Parar todos los servicios"
    Write-Host "restart        " -ForegroundColor Green -NoNewline; Write-Host "- Reiniciar todos los servicios"
    Write-Host "clean          " -ForegroundColor Green -NoNewline; Write-Host "- Limpiar contenedores, imágenes y volúmenes"
    Write-Host "logs           " -ForegroundColor Green -NoNewline; Write-Host "- Ver logs de todos los servicios"
    Write-Host "logs-auth      " -ForegroundColor Green -NoNewline; Write-Host "- Ver logs del servicio de autenticación"
    Write-Host "logs-loans     " -ForegroundColor Green -NoNewline; Write-Host "- Ver logs del servicio de solicitudes"
    Write-Host "status         " -ForegroundColor Green -NoNewline; Write-Host "- Ver el estado de todos los servicios"
    Write-Host "health         " -ForegroundColor Green -NoNewline; Write-Host "- Verificar el health de los microservicios"
    Write-Host "shell-auth     " -ForegroundColor Green -NoNewline; Write-Host "- Entrar al contenedor de autenticación"
    Write-Host "shell-loans    " -ForegroundColor Green -NoNewline; Write-Host "- Entrar al contenedor de solicitudes"
    Write-Host "help           " -ForegroundColor Green -NoNewline; Write-Host "- Mostrar esta ayuda"
    Write-Host ""
}

# Función para construir imágenes
function Build-Images {
    Write-Host "Construyendo imágenes..." -ForegroundColor Blue
    docker-compose build --no-cache
    if ($LASTEXITCODE -eq 0) {
        Write-Host "¡Imágenes construidas exitosamente!" -ForegroundColor Green
    } else {
        Write-Host "Error al construir las imágenes" -ForegroundColor Red
    }
}

# Función para iniciar servicios
function Start-Services {
    Write-Host "Iniciando servicios..." -ForegroundColor Blue
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "¡Servicios iniciados!" -ForegroundColor Green
        Write-Host ""
        Show-Status
    } else {
        Write-Host "Error al iniciar los servicios" -ForegroundColor Red
    }
}

# Función para parar servicios
function Stop-Services {
    Write-Host "Parando servicios..." -ForegroundColor Yellow
    docker-compose down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "¡Servicios detenidos!" -ForegroundColor Green
    } else {
        Write-Host "Error al parar los servicios" -ForegroundColor Red
    }
}

# Función para reiniciar servicios
function Restart-Services {
    Write-Host "Reiniciando servicios..." -ForegroundColor Yellow
    docker-compose restart
    if ($LASTEXITCODE -eq 0) {
        Write-Host "¡Servicios reiniciados!" -ForegroundColor Green
    } else {
        Write-Host "Error al reiniciar los servicios" -ForegroundColor Red
    }
}

# Función para limpiar todo
function Clean-All {
    $response = Read-Host "¿Estás seguro que quieres limpiar todo? Esto eliminará contenedores, imágenes y volúmenes. [y/N]"
    if ($response -match "^[yYsS]$") {
        Write-Host "Limpiando..." -ForegroundColor Yellow
        docker-compose down -v --rmi all --remove-orphans
        docker system prune -f
        Write-Host "¡Limpieza completada!" -ForegroundColor Green
    } else {
        Write-Host "Operación cancelada." -ForegroundColor Blue
    }
}

# Función para ver logs
function Show-Logs {
    Write-Host "Mostrando logs (Ctrl+C para salir)..." -ForegroundColor Blue
    docker-compose logs -f
}

# Función para ver logs de autenticación
function Show-AuthLogs {
    Write-Host "Mostrando logs de Autenticación (Ctrl+C para salir)..." -ForegroundColor Blue
    docker-compose logs -f autenticacion
}

# Función para ver logs de solicitudes
function Show-LoansLogs {
    Write-Host "Mostrando logs de Solicitudes (Ctrl+C para salir)..." -ForegroundColor Blue
    docker-compose logs -f solicitudes
}

# Función para ver estado
function Show-Status {
    Write-Host "Estado de los servicios:" -ForegroundColor Blue
    docker-compose ps
    Write-Host ""
    Write-Host "Uso de recursos:" -ForegroundColor Blue
    docker stats --no-stream --format "table {{.Container}}`t{{.CPUPerc}}`t{{.MemUsage}}`t{{.NetIO}}"
}

# Función para verificar health
function Check-Health {
    Write-Host "Verificando health de los microservicios..." -ForegroundColor Blue
    Write-Host ""
    
    Write-Host "Autenticación (puerto 8081):" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8081/actuator/health" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ Servicio de Autenticación está funcionando" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Servicio de Autenticación no responde" -ForegroundColor Red
    }
    
    Write-Host "Solicitudes (puerto 8082):" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8082/actuator/health" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ Servicio de Solicitudes está funcionando" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Servicio de Solicitudes no responde" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "URLs disponibles:" -ForegroundColor Blue
    Write-Host "- Autenticación: http://localhost:8081"
    Write-Host "- Solicitudes: http://localhost:8082"
    Write-Host "- PgAdmin: http://localhost:5050"
}

# Función para entrar al shell de autenticación
function Enter-AuthShell {
    Write-Host "Entrando al contenedor de Autenticación..." -ForegroundColor Blue
    docker-compose exec autenticacion sh
}

# Función para entrar al shell de solicitudes
function Enter-LoansShell {
    Write-Host "Entrando al contenedor de Solicitudes..." -ForegroundColor Blue
    docker-compose exec solicitudes sh
}

# Verificar que Docker Compose esté disponible
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "Error: docker-compose no está instalado o no está en el PATH" -ForegroundColor Red
    exit 1
}

# Función principal
switch ($Command.ToLower()) {
    "build" { Build-Images }
    "start" { Start-Services }
    "stop" { Stop-Services }
    "restart" { Restart-Services }
    "clean" { Clean-All }
    "logs" { Show-Logs }
    "logs-auth" { Show-AuthLogs }
    "logs-loans" { Show-LoansLogs }
    "status" { Show-Status }
    "health" { Check-Health }
    "shell-auth" { Enter-AuthShell }
    "shell-loans" { Enter-LoansShell }
    default { Show-Help }
}
