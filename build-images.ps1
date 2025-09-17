# Script para construir las imágenes de los microservicios
# Ejecutar desde la carpeta padre que contiene todos los repos

Write-Host "🔨 Construyendo imagen de Autenticación..." -ForegroundColor Yellow
Set-Location "../pragma-credi-ya-usuario"
docker build -f deployment/Dockerfile -t pragmacrediya-autenticacion:latest .

Write-Host "🔨 Construyendo imagen de Solicitudes..." -ForegroundColor Yellow
Set-Location "../pragma-credi-ya-solicitud"
docker build -f deployment/Dockerfile -t pragmacrediya-solicitudes:latest .

Write-Host "✅ Imágenes construidas exitosamente!" -ForegroundColor Green

# Regresar al directorio de infraestructura
Set-Location "../pragma-credi-ya-infraestructura"

Write-Host "🚀 Puedes ejecutar ahora: docker-compose up -d" -ForegroundColor Cyan
