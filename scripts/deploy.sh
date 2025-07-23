#!/bin/bash

# Script para desplegar en producción

echo "🚀 Iniciando despliegue de producción..."

# Verificar que existe el archivo .env
if [ ! -f .env ]; then
    echo "❌ Error: Archivo .env no encontrado. Copia .env.example a .env y configura las variables."
    exit 1
fi

# Construir y desplegar
echo "📦 Construyendo contenedores..."
docker-compose build

echo "🔄 Deteniendo servicios existentes..."
docker-compose down

echo "🚀 Iniciando servicios..."
docker-compose up -d

echo "⏳ Esperando que los servicios estén listos..."
sleep 30

echo "🔍 Verificando estado de los servicios..."
docker-compose ps

echo "🌐 Probando conectividad..."
curl -f http://localhost/health && echo "✅ Nginx respondiendo correctamente"

echo "✨ ¡Despliegue completado!"
echo "🌐 Aplicación disponible en: http://localhost"
echo "📊 Dashboard disponible en: http://localhost/dashboard"
echo "🤖 RAG/Chatbot disponible en: http://localhost/rag"
