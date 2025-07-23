#!/bin/bash

# Script para desarrollo local

echo "🛠️ Iniciando entorno de desarrollo..."

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado"
    exit 1
fi

# Iniciar servicios de desarrollo
echo "🚀 Iniciando servicios de desarrollo..."
docker-compose -f docker-compose.dev.yml up -d

echo "⏳ Esperando que los servicios estén listos..."
sleep 30

echo "🔍 Estado de los servicios:"
docker-compose -f docker-compose.dev.yml ps

echo "✨ ¡Entorno de desarrollo listo!"
echo "🌐 Frontend: http://localhost:3001"
echo "🔧 Backend API: http://localhost:3000"
echo "📊 Dashboard: http://localhost:3002"
echo "🤖 RAG Service: http://localhost:5000"
echo "🗄️ PostgreSQL: localhost:5433"

echo ""
echo "Para ver los logs: docker-compose -f docker-compose.dev.yml logs -f"
echo "Para detener: docker-compose -f docker-compose.dev.yml down"
