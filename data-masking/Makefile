DSN := "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"
INDEXES_DIR := ../views-and-indexes/migrations
FILLING_DIR := ../making-postgres-tables/migrations
MIGRATE_DIR := ./migrations

up:
	@docker-compose --env-file .env.dev -f ../making-postgres-tables/docker-compose.yml up

new:
	@migrate create -ext sql -dir $(MIGRATE_DIR) $(NAME)

pre:
	@migrate -path $(FILLING_DIR) -database ${DSN} down -all
	@migrate -path $(FILLING_DIR) -database ${DSN} up
	@docker exec -it making-postgres-tables_psql_1 psql -U postgres -c "DROP TABLE schema_migrations;"
	@migrate -path $(INDEXES_DIR) -database ${DSN} up
	@docker exec -it making-postgres-tables_psql_1 psql -U postgres -c "DROP TABLE schema_migrations;"

_up:
	@migrate -path $(MIGRATE_DIR) -database ${DSN} up

apply: pre _up