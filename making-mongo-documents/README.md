## MongoDB for Booking System

- Fadeyev Artyom M34021
- Making design of a https://booking.com
- MongoDB as a DB

### Importing data from RDBMS

I wrote copy sql queries to [migrate-to-mongo.sql](migrate-to-mongo.sql) file.

Example:

```sql
copy (
    select row_to_json(rows)
    from (select "user".id,
                 "user".name,
                 "user".email,
                 "user".username,
                 "user".hashed_password,
                 case
                     when user_contact.id is null then null
                     else
                         json_build_object(
                                 'id', user_contact.id,
                                 'phone', user_contact.phone,
                                 'address', user_contact.address
                         )
                     end as contacts
          from "user"
                   left join user_contact
                             on "user".id = user_contact.user_id) rows
    ) to '/tmp/users.json' with (format text, header false);
```

Following commands are making dump of data from RDBMS to json files,
because structure of documents in MongoDB is different from structure of tables in RDBMS.

Then I wrote bash script to import data from json files to MongoDB with `mongoimport` command.

```bash
declare  collections=(
  "userCollection" "users.json"
  "amenityCollection" "amenities.json"
  "reviewCollection" "reviews.json"
  "hotelCollection" "hotels.json"
  "bookingCollection" "bookings.json"
)

for ((i=0; i<${#collections[@]}; i+=2)); do
  collection=${collections[i]}
  file=${collections[i+1]}

  echo "Importing $collection from $file"
  mongoimport --uri "${DSN}" --collection "${collection}" \
    --file "${ARTIFACTS}"/"${file}"
done
```

### Collections

Collections can be created manually or by inserting data into them.

### Indexes

I'm a lazy one, so I used Go to write mongo queries.

```go
func main() {
    // ... 
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
    // ...
}
```

I explained find with and without index, here are results:

```json
// ...
    "winningPlan": {
      "stage": "COLLSCAN",
      "filter": {
        "$and": [
          {
            "rooms.price": {
              "$lt": 200
            }
          },
          {
            "rooms.capacity": {
              "$gt": 2
            }
          },
          {
            "rooms.price": {
              "$gt": 100
            }
          }
        ]
      },
      "direction": "forward"
    },
// ...
```

```json
// ...
    "winningPlan": {
        "isUnique": false,
        "isSparse": false,
        "isPartial": false,
        "indexVersion": 2,
        "stage": "IXSCAN",
// ...
```

### Views

Again, I'm a lazy one, so I used Go to write mongo queries.

```go
// create view on reviewCollection
// where rating is greater than 7
// and user is provided any of his contacts information
// by this we will require that user is not bot

func main() {
    // ...
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
    // ...
}
```

Here how it looks like:

```json
{
  "result": "reviewMoreThan7NotBotView",
  "ok": 1
}
```
