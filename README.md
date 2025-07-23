# E-commerce Platform with RAG Chatbot

Un sistema completo de e-commerce con 4 aplicaciones integradas:
- **Frontend**: Aplicación React para clientes
- **Backend**: API REST en Node.js/Express
- **Dashboard**: Panel de administración en Next.js
- **RAG**: Servicio de chatbot con inteligencia artificial

## 🏗️ Arquitectura

```
┌─────────────────┐
│      Nginx      │ ← Proxy reverso (Puerto 80/443)
│   Load Balancer │
└─────────────────┘
         │
    ┌────┴────┐
    │         │         │         │
┌───▼───┐ ┌──▼──┐ ┌────▼───┐ ┌──▼──┐
│Frontend│ │Backend│ │Dashboard│ │ RAG │
│React   │ │Node.js│ │ Next.js │ │Flask│
│:80     │ │:3000  │ │  :3000  │ │:5000│
└────────┘ └───────┘ └─────────┘ └─────┘
              │
         ┌────▼────┐
         │PostgreSQL│
         │  :5432   │
         └──────────┘
```

## 🚀 Despliegue Rápido

### Prerrequisitos
- Docker y Docker Compose instalados
- Git
- Al menos 4GB de RAM disponibles

### 1. Configuración inicial

```bash
# Clonar el repositorio
git clone <tu-repositorio>
cd ecommerce

# Copiar variables de entorno
cp .env.example .env

# Editar variables de entorno
nano .env  # o tu editor preferido
```

### 2. Despliegue en Producción

**Opción A: Usando Make (recomendado)**
```bash
make prod
```

**Opción B: Usando Docker Compose**
```bash
docker-compose build
docker-compose up -d
```

**Opción C: Usando scripts**
```bash
# Linux/Mac
./scripts/deploy.sh

# Windows
scripts\deploy.bat
```

### 3. Verificar despliegue

```bash
# Ver estado de servicios
make status

# Ver logs
make logs

# Probar endpoints
curl http://localhost/health
```

## 🛠️ Desarrollo Local

### Iniciar entorno de desarrollo
```bash
# Opción A: Make
make dev

# Opción B: Docker Compose
docker-compose -f docker-compose.dev.yml up -d
```

### URLs de desarrollo
- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:3000
- **Dashboard**: http://localhost:3002
- **RAG Service**: http://localhost:5000
- **PostgreSQL**: localhost:5433

### Comandos útiles
```bash
# Ver logs de desarrollo
make dev-logs

# Ejecutar tests
make test

# Detener desarrollo
make dev-down
```

## 📊 URLs de Producción

Una vez desplegado, las aplicaciones estarán disponibles en:

- **Sitio principal**: http://tu-dominio.com/
- **API**: http://tu-dominio.com/api/
- **Dashboard Admin**: http://tu-dominio.com/dashboard/
- **Chatbot RAG**: http://tu-dominio.com/rag/
- **Health Check**: http://tu-dominio.com/health

## 🔧 Configuración VPS

### Configuración del servidor
```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Crear directorio del proyecto
sudo mkdir -p /opt/ecommerce
sudo chown $USER:$USER /opt/ecommerce
cd /opt/ecommerce

# Clonar repositorio
git clone <tu-repositorio> .
```

### Configurar CI/CD

1. **Generar clave SSH para el VPS**:
```bash
ssh-keygen -t rsa -b 4096 -C "deploy@ecommerce"
```

2. **Agregar secrets en GitHub**:
   - `VPS_HOST`: IP de tu VPS
   - `VPS_USERNAME`: Usuario SSH
   - `VPS_SSH_KEY`: Clave privada SSH
   - `VPS_PORT`: Puerto SSH (por defecto 22)

3. **Configurar variables de entorno en el VPS**:
```bash
cd /opt/ecommerce
cp .env.example .env
nano .env  # Configurar variables reales
```

### SSL/HTTPS (Opcional)
```bash
# Instalar Certbot
sudo apt install certbot

# Generar certificados
make ssl-setup
```

## 🔍 Monitoreo y Mantenimiento

### Comandos de mantenimiento
```bash
# Backup de base de datos
make backup-db

# Restaurar backup
make restore-db BACKUP_FILE=backup_20240101_120000.sql


# Limpiar sistema
make clean

# Actualizar servicios
make update

# Ver recursos utilizados
docker stats
```

### Logs importantes
```bash
# Logs de aplicación
docker-compose logs -f

# Logs de nginx
docker-compose logs nginx

# Logs de base de datos
docker-compose logs postgres
```

## 🚨 Troubleshooting

### Problemas comunes

**1. Puerto 80 ocupado**
```bash
sudo lsof -i :80
sudo systemctl stop apache2  # si Apache está corriendo
```

**2. Problemas de memoria**
```bash
# Limpiar imágenes no utilizadas
docker system prune -a
```

**3. Base de datos no conecta**
```bash
# Verificar logs de PostgreSQL
docker-compose logs postgres

# Reiniciar solo la base de datos
docker-compose restart postgres
```

**4. SSL no funciona**
```bash
# Verificar certificados
ls -la ./ssl/
make ssl-setup
```

## 📝 Variables de Entorno

### Requeridas
- `DATABASE_URL`: URL de conexión a PostgreSQL
- `JWT_SECRET`: Clave secreta para JWT
- `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`: Configuración de DB

### Opcionales
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`: OAuth Google
- `OPENAI_API_KEY`: Para el servicio RAG
- `SSL_CERT_PATH`, `SSL_KEY_PATH`: Certificados SSL

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -am 'Agregar nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

**Desarrollado por Henry-GC** 🚀