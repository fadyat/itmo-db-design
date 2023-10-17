DSN := "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"
INDEXES_DIR := ../views-and-indexes/migrations
FILL_DIR := ../making-postgres-tables/migrations
MIGRATIONS_DIR := ./migrations

up:
	@docker-compose --env-file .env.dev -f ../making-postgres-tables/docker-compose.yml up

new:
	@migrate create -ext sql -dir $(MIGRATIONS_DIR) $(NAME)

pre:
	@migrate -path $(FILL_DIR) -database ${DSN} down -all
	@migrate -path $(FILL_DIR) -database ${DSN} up
	@docker exec -it making-postgres-tables_psql_1 psql -U postgres -c "DROP TABLE schema_migrations;"
	@migrate -path $(INDEXES_DIR) -database ${DSN} up
	@docker exec -it making-postgres-tables_psql_1 psql -U postgres -c "DROP TABLE schema_migrations;"

down:
	@migrate -path $(MIGRATIONS_DIR) -database ${DSN} down -all

_up:
	@migrate -path $(MIGRATIONS_DIR) -database ${DSN} up

apply: down _up