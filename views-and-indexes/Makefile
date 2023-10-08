DSN := "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"
MIGRATIONS_DIR := ./migrations
FILL_DIR := ../making-postgres-tables/migrations

up:
	@docker-compose -f ../making-postgres-tables/docker-compose.yml up

new:
	@migrate create -ext sql -dir $(MIGRATIONS_DIR) $(NAME)

fill:
	@migrate -path $(FILL_DIR) -database ${DSN} down -all
	@migrate -path $(FILL_DIR) -database ${DSN} up
	@docker exec -it making-postgres-tables_psql_1 psql -U postgres -c "DROP TABLE schema_migrations;"

down:
	@migrate -path $(MIGRATIONS_DIR) -database ${DSN} down -all

_up:
	@migrate -path $(MIGRATIONS_DIR) -database ${DSN} up

apply: down _up


.PHONY: up apply new fill down