DSN := "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"
FILLING_DIR := ../making-postgres-tables/migrations
INDEXES_DIR := ../views-and-indexes/migrations
MASKING_DIR := ../data-masking/migrations
MIGRATE_DIR := ./migrations
CONTAINER_NAME := making-postgres-tables-psql-1

up:
	@docker-compose --env-file ../data-masking/.env.dev -f ../making-postgres-tables/docker-compose.yml up

kill:
	@docker kill making-postgres-tables-psql-1 || true

new:
	@migrate create -ext sql -dir $(MIGRATE_DIR) $(NAME)

pre:
	@migrate -path $(FILLING_DIR) -database ${DSN} down -all
	@migrate -path $(FILLING_DIR) -database ${DSN} up
	@docker exec -it $(CONTAINER_NAME) psql -U postgres -c "DROP TABLE schema_migrations;"
	@migrate -path $(INDEXES_DIR) -database ${DSN} up
	@docker exec -it $(CONTAINER_NAME) psql -U postgres -c "DROP TABLE schema_migrations;"
	@migrate -path $(MASKING_DIR) -database ${DSN} up
	@docker exec -it $(CONTAINER_NAME) psql -U postgres -c "DROP VIEW mask.schema_migrations; DROP TABLE schema_migrations;"

clean:
	@rm -rf ../making-postgres-tables/postgresql_data || true

_up:
	@migrate -path $(MIGRATE_DIR) -database ${DSN} down -all
	@migrate -path $(MIGRATE_DIR) -database ${DSN} up

apply: pre _up

restart: kill clean up