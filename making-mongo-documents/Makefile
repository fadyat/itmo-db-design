CONTAINER_NAME := making-mongo-documents_mongo_1
DSN := "mongodb://admin:admin@localhost:27017/test?sslmode=disable&authSource=admin"

up-postgres:
	@docker-compose --env-file .env.dev -f ../making-postgres-tables/docker-compose.yml up -d psql
	@while ! docker exec -it making-postgres-tables_psql_1 pg_isready; do sleep 2; done
	@make -C ../making-postgres-tables apply

up:
	@docker-compose -f docker-compose.yml up

kill:
	@docker kill $(CONTAINER_NAME) || true

clean:
	@rm -rf ./mongodb_data || true

restart: kill clean up

import:
	@chmod +x ./import.sh
	@./import.sh

.PHONY: up up-postgres kill restart clean

