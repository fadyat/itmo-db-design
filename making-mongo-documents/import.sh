#!/bin/bash

DSN="mongodb://admin:admin@localhost:27017/test?sslmode=disable&authSource=admin"
ARTIFACTS="./postgres-artifacts"

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
