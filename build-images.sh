#!/bin/bash
# Script para construir las imágenes de los microservicios
# Ejecutar desde la carpeta padre que contiene todos los repos

echo "🔨 Construyendo imagen de Autenticación..."
cd "../pragma-credi-ya-usuario"
docker build -f deployment/Dockerfile -t pragmacrediya-autenticacion:latest .

echo "🔨 Construyendo imagen de Solicitudes..."
cd "../pragma-credi-ya-solicitud"
docker build -f deployment/Dockerfile -t pragmacrediya-solicitudes:latest .

echo "✅ Imágenes construidas exitosamente!"

# Regresar al directorio de infraestructura
cd "../pragma-credi-ya-infraestructura"

echo "🚀 Puedes ejecutar ahora: docker-compose up -d"
