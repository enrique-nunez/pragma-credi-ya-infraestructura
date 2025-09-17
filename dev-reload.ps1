Write-Host "Deteniendo contenedores..." -ForegroundColor Yellow
docker-compose down

Write-Host "Construyendo imagenes..." -ForegroundColor Cyan
.\build-images.ps1

Write-Host "Levantando servicios..." -ForegroundColor Green
docker-compose up -d

Write-Host "Proceso completado!" -ForegroundColor Green