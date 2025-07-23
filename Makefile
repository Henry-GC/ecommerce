.PHONY: help build up down logs restart clean dev prod test

# Variables
COMPOSE_FILE=docker-compose.yml
DEV_COMPOSE_FILE=docker-compose.dev.yml

help: ## Mostrar esta ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Construir todas las imágenes
	docker-compose -f $(COMPOSE_FILE) build

up: ## Iniciar todos los servicios en producción
	docker-compose -f $(COMPOSE_FILE) up -d

down: ## Detener todos los servicios
	docker-compose -f $(COMPOSE_FILE) down

logs: ## Ver logs de todos los servicios
	docker-compose -f $(COMPOSE_FILE) logs -f

restart: ## Reiniciar todos los servicios
	docker-compose -f $(COMPOSE_FILE) restart

clean: ## Limpiar contenedores, imágenes y volúmenes no utilizados
	docker system prune -f
	docker volume prune -f

dev: ## Iniciar entorno de desarrollo
	docker-compose -f $(DEV_COMPOSE_FILE) up -d

dev-down: ## Detener entorno de desarrollo
	docker-compose -f $(DEV_COMPOSE_FILE) down

dev-logs: ## Ver logs del entorno de desarrollo
	docker-compose -f $(DEV_COMPOSE_FILE) logs -f

test: ## Ejecutar tests en todos los servicios
	docker-compose -f $(DEV_COMPOSE_FILE) exec backend npm test || true
	docker-compose -f $(DEV_COMPOSE_FILE) exec frontend npm test -- --watchAll=false || true
	docker-compose -f $(DEV_COMPOSE_FILE) exec dashboard npm run lint || true
	docker-compose -f $(DEV_COMPOSE_FILE) exec rag python -m pytest tests/ || true

prod: build up ## Construir y desplegar en producción

status: ## Ver estado de los servicios
	docker-compose -f $(COMPOSE_FILE) ps

backup-db: ## Crear backup de la base de datos
	docker-compose -f $(COMPOSE_FILE) exec postgres pg_dump -U $$POSTGRES_USER $$POSTGRES_DB > backup_$(shell date +%Y%m%d_%H%M%S).sql

restore-db: ## Restaurar base de datos (usar con BACKUP_FILE=archivo.sql)
	docker-compose -f $(COMPOSE_FILE) exec -T postgres psql -U $$POSTGRES_USER $$POSTGRES_DB < $(BACKUP_FILE)

ssl-setup: ## Configurar certificados SSL (requiere certbot)
	sudo certbot certonly --webroot -w ./ssl -d yourdomain.com
	sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ./ssl/cert.pem
	sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ./ssl/key.pem
	sudo chown $$USER:$$USER ./ssl/*.pem

update: ## Actualizar imágenes y reiniciar servicios
	docker-compose -f $(COMPOSE_FILE) pull
	docker-compose -f $(COMPOSE_FILE) up -d
