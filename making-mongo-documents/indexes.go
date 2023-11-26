package main

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"log"
	"os/exec"
)

func storeJson(
	path string,
	result bson.M,
) (err error) {
	var resultJson []byte
	resultJson, err = bson.MarshalExtJSON(result, false, false)
	if err != nil {
		return fmt.Errorf("failed to marshal result to JSON: %w", err)
	}

	var cmd = fmt.Sprintf("echo '%s' | jq . > %s", string(resultJson), path)
	_, err = exec.Command("bash", "-c", cmd).Output()
	if err != nil {
		return fmt.Errorf("failed to run jq: %w", err)
	}

	return nil
}

func main() {
	dsn := "mongodb://admin:admin@localhost:27017/test?sslmode=disable&authSource=admin"
	db, err := mongo.Connect(context.Background(), options.Client().ApplyURI(dsn))
	if err != nil {
		log.Fatalf("failed to connect to MongoDB: %v", err)
	}

	defer func() {
		if err = db.Disconnect(context.Background()); err != nil {
			log.Fatalf("failed to disconnect from MongoDB: %v", err)
		}
	}()

	// explain select from the hotelCollection,
	// when searching for a rooms with a price in some range
	findCommand := bson.D{
		{"find", "hotelCollection"},
		{"filter", bson.D{
			{"rooms.price", bson.D{
				{"$gt", 100},
				{"$lt", 200},
			}},
			{"rooms.capacity", bson.D{
				{"$gt", 2},
			}},
		}},
	}

	explainCommand := bson.D{
		{"explain", findCommand},
	}

	var result bson.M
	err = db.Database("test").
		RunCommand(context.Background(), explainCommand).
		Decode(&result)

	if err != nil {
		log.Fatalf("failed to execute explain command: %v", err)
	}

	if err = storeJson("./explain/no_index.json", result); err != nil {
		log.Fatalf("failed to store explain result: %v", err)
	}

	// create index on rooms.price field
	indexModel := mongo.IndexModel{
		Keys: bson.D{
			{"rooms.price", 1},
			{"rooms.capacity", 1},
		},
	}

	_, err = db.Database("test").
		Collection("hotelCollection").
		Indexes().
		CreateOne(context.Background(), indexModel)

	if err != nil {
		log.Fatalf("failed to create index: %v", err)
	}

	// explain select from the hotelCollection,
	// when searching for a rooms with a price in some range
	result = bson.M{}
	err = db.Database("test").
		RunCommand(context.Background(), explainCommand).
		Decode(&result)

	if err != nil {
		log.Fatalf("failed to execute explain command: %v", err)
	}

	if err = storeJson("./explain/with_index.json", result); err != nil {
		log.Fatalf("failed to store explain result: %v", err)
	}

	// drop index on rooms.price and rooms.capacity fields
	_, err = db.Database("test").
		Collection("hotelCollection").
		Indexes().
		DropOne(context.Background(), "rooms.price_1_rooms.capacity_1")

	if err != nil {
		log.Fatalf("failed to drop index: %v", err)
	}
}
