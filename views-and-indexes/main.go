package main

import (
	"fmt"
	"log"
	"math/rand"
	"strings"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func insertUserBatch(db *sqlx.DB, startIndex, batchSize int) error {
	query := `
insert into "user" (id, name, email, username, hashed_password) values %s
`

	var values []string
	for i := startIndex; i < startIndex+batchSize; i++ {
		value := fmt.Sprintf("(%d, 'name%d', 'email%d', 'username%d', 'hashed_password%d')", i, i, i, i, i)
		values = append(values, value)
	}

	query = fmt.Sprintf(query, strings.Join(values, ","))
	_, err := db.Exec(query)
	return err
}

func insertRoomBatch(db *sqlx.DB, startIndex, batchSize int) error {
	query := `
insert into room (id, name, capacity, price, active, hotel_id) values %s
`

	var (
		values                 []string
		hotelID                = 1
		priceLB, priceUB       = 100, 1000
		capacityLB, capacityUB = 1, 10
	)

	for i := startIndex; i < startIndex+batchSize; i++ {
		price, capacity := rnd(priceLB, priceUB), rnd(capacityLB, capacityUB)
		value := fmt.Sprintf("(%d, 'name%d', %d, %d, true, %d)", i, i, capacity, price, hotelID)
		values = append(values, value)
	}

	query = fmt.Sprintf(query, strings.Join(values, ","))
	_, err := db.Exec(query)
	return err
}

func rnd(min, max int) int {
	return rand.Intn(max-min) + min
}

func insertBookingBatch(db *sqlx.DB, startIndex, batchSize int) error {
	query := "insert into booking (id, start_date, end_date, price, status, user_id, room_id) values %s"

	var (
		roomLB, roomUB = 1, 15
		userLB, userUB = 1000, 2000
		dateLB, dateUB = 10, 20
		statuses       = []string{"pending", "approved", "rejected"}
	)

	for i := startIndex; i < startIndex+batchSize; i++ {
		roomID, userID := rnd(roomLB, roomUB), rnd(userLB, userUB)
		startDate, endDate := rnd(dateLB, dateUB), rnd(dateLB, dateUB)+1
		price, status := rnd(100, 1000), statuses[rand.Intn(len(statuses))]
		value := fmt.Sprintf("(%d, '2020-01-%d', '2020-01-%d', %d, '%s', %d, %d)", i, startDate, endDate, price, status, userID, roomID)
		_, err := db.Exec(fmt.Sprintf(query, value))
		if err != nil {
			log.Println(err)
		}
	}

	return nil
}

func main() {
	dsn := "postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable"
	db, err := sqlx.Connect("postgres", dsn)
	if err != nil {
		log.Fatalln(err)
	}

	var (
		startIndex = 1000
		batchSize  = 1000
		total      = 100000
	)

	for i := startIndex; i < total; i += batchSize {
		if e := insertBookingBatch(db, i, batchSize); e != nil {
			log.Println(e)
		}
	}

	var count int
	err = db.Get(&count, "select count(*) from \"user\"")
	if err != nil {
		log.Println(err)
	}

	fmt.Println(count)
}
