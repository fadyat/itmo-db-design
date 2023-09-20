DSN := "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"

up:
	@docker-compose up psql

drop:
	@migrate -path ./migrations -database ${DSN} drop

apply:
	@migrate -path ./migrations -database ${DSN} down -all
	@migrate -path ./migrations -database ${DSN} up

.PHONY: up apply