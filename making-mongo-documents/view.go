package main

import (
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"log"
)

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

	// create view on reviewCollection
	// where rating is greater than 7
	createViewCommand := bson.D{
		{"create", "reviewMoreThan7View"},
		{"viewOn", "reviewCollection"},
		{"pipeline", bson.A{
			bson.D{
				{"$match", bson.D{
					{"rating", bson.D{
						{"$gt", 7},
					}},
				}},
			},
			bson.D{
				{"$project", bson.D{
					{"_id", 0},
				}},
			},
		}},
	}

	var result bson.M
	err = db.Database("test").
		RunCommand(context.Background(), createViewCommand).
		Decode(&result)

	if err != nil {
		log.Fatalf("failed to execute create view command: %v", err)
	}

	// create view on reviewCollection
	// where rating is greater than 7
	// and user is provided any of his contacts information
	// by this we will require that user is not bot
	createViewCommand = bson.D{
		{"create", "reviewMoreThan7NotBotView"},
		{"viewOn", "reviewCollection"},
		{"pipeline", bson.A{
			bson.D{
				{"$lookup", bson.D{
					{"from", "userCollection"},
					{"localField", "user_id"},
					{"foreignField", "id"},
					{"as", "user"},
				}},
			},
			bson.D{
				{"$unwind", "$user"},
			},
			bson.D{
				{"$match", bson.D{
					{"rating", bson.D{
						{"$gt", 7},
					}},
					{"user.contacts", bson.D{
						{"$ne", nil},
					}},
				}},
			},
			bson.D{
				{"$project", bson.D{
					{"_id", 0},
					{"user", 0},
				}},
			},
		}},
	}

	err = db.Database("test").
		RunCommand(context.Background(), createViewCommand).
		Decode(&result)

	if err != nil {
		log.Fatalf("failed to execute create view command: %v", err)
	}

}
