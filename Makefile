# Project-wide variables
COMPOSE=docker compose -f docker-compose.update.yml

# 🐳 Docker Compose Dev
up:
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) down && $(COMPOSE) up --build

logs:
	$(COMPOSE) logs -f

# 🚀 Production Build
build:
	$(COMPOSE_PROD) build

prod-up:
	$(COMPOSE_PROD) up -d

prod-down:
	$(COMPOSE_PROD) down

# 🧼 Clean up
prune:
	docker system prune -af

# 🧪 Build & Run Individual Services (Dev)
build-go:
	docker build \
		-t api-golang \
		-f ./api-golang/Dockerfile.update \
		--target dev \
		.

build-node:
	docker build \
		-t api-node \
		-f ./api-node/Dockerfile.update \
		--target dev \
		.

build-vite:
	docker build \
		-t client-react \
		-f ./client-react/Dockerfile.update \
		--target dev \
		.

db:
	docker run \
		--name postgres-container \
		-e POSTGRES_PASSWORD=mysecretpassword \
		-p 5432:5432 \
		--network fullstack-net \
		-d postgres:15.1-alpine

dev-golang:
	docker run --rm -it \
		--name api-golang-container \
		-p 8080:8080 \
		-e DATABASE_URL=postgres://postgres:mysecretpassword@postgres-container:5432/postgres \
		--network fullstack-net \
		-v ${PWD}/api-golang:/app \
		api-golang

dev-node:
	docker run --rm -it \
		--name api-node-container \
		-p 3000:3000 \
		-e DATABASE_URL=postgres://postgres:mysecretpassword@postgres-container:5432/postgres \
		--network fullstack-net \
		-v ${PWD}/api-node:/usr/src/app \
		api-node

dev-react:
	docker run --rm -it \
		--name client-react-container \
		-p 3001:3001 \
		--network fullstack-net \
		-v ${PWD}/client-react:/usr/src/app \
		client-react
