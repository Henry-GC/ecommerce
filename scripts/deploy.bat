@echo off
echo 🚀 Iniciando despliegue de producción...

REM Verificar que existe el archivo .env
if not exist .env (
    echo ❌ Error: Archivo .env no encontrado. Copia .env.example a .env y configura las variables.
    exit /b 1
)

REM Construir y desplegar
echo 📦 Construyendo contenedores...
docker-compose build

echo 🔄 Deteniendo servicios existentes...
docker-compose down

echo 🚀 Iniciando servicios...
docker-compose up -d

echo ⏳ Esperando que los servicios estén listos...
timeout /t 30 /nobreak

echo 🔍 Verificando estado de los servicios...
docker-compose ps

echo ✨ ¡Despliegue completado!
echo 🌐 Aplicación disponible en: http://localhost
echo 📊 Dashboard disponible en: http://localhost/dashboard
echo 🤖 RAG/Chatbot disponible en: http://localhost/rag

pause
