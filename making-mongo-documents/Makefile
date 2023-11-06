CONTAINER_NAME := making-mongo-documents_mongo_1
DSN := "mongodb://admin:admin@localhost:27017/test?sslmode=disable&authSource=admin"

up:
	@docker-compose -f docker-compose.yml up

new:
	@migrate create -ext json -dir ./migrations $(NAME)

apply:
	@migrate -path ./migrations -database ${DSN} down -all
	@migrate -path ./migrations -database ${DSN} up

kill:
	@docker kill $(CONTAINER_NAME) || true

clean:
	@rm -rf ./mongodb_data || true

restart: kill clean up

.PHONY: up kill new apply restart clean

