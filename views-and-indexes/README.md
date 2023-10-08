## Views and Indexes for Booking System

- Fadeyev Artyom M34021
- Making design of a https://booking.com
- PostgreSQL as a DB

### Views

I decided to create the following two views:

- `room_with_amenities` - view with all amenities for each room

    ```sql
    create view room_with_amenities as
    select room.id,
           room.capacity,
           room.name,
           room.active,
           room.price,
           room.hotel_id,
           json_agg(amenity.name) as amenities
    from room
             join room_amenity
                  on room.id = room_amenity.room_id
             join amenity
                  on room_amenity.amenity_id = amenity.id
    group by room.id;

    -- postgres=# select * from room_with_amenities;
    --  id | capacity |        name        | active | price | hotel_id |                         amenities                         
    -- ----+----------+--------------------+--------+-------+----------+-----------------------------------------------------------
    --   1 |        2 | Standard Room      | t      |   100 |        1 | ["Wi-Fi"]
    --   6 |        6 | Presidential Suite | t      |   500 |        1 | ["Spa", "Bar", "Parking", "Sauna", "Gym", "Room Service"]
    -- (2 rows)
    ```


- `hotel_with_rating` - view with average rating and reviews count for each hotel

  ```sql
  create view hotel_with_rating as
  select hotel.id,
         hotel.name,
         avg(review.rating) as rating,
         count(review.id)   as reviews_count
  from hotel
           join review
                on hotel.id = review.booking_id
           join booking
                on review.booking_id = booking.id
           join room
                on booking.room_id = room.id
  group by hotel.id;
  
  -- postgres=# select * from hotel_with_rating limit 5;
  --    id |       name        |       rating        | reviews_count 
  --   ----+-------------------+---------------------+---------------
  --     1 | Grand Hotel       |  7.5000000000000000 |             2
  --     2 | Seaside Resort    | 10.0000000000000000 |             1
  --     3 | Mountain Lodge    |  7.0000000000000000 |             1
  --     4 | City View Inn     | 10.0000000000000000 |             1
  --     5 | Riverside Retreat |  5.0000000000000000 |             1
  --   (5 rows)
  ```

### Indexes

I created the following indexes:

- `idx_room_capacity_price` - index for `room` table on `capacity` and `price` columns
  > So often we need to find a room with specific requirements.

  ```sql
  create index idx_rooms_capacity_price on room (capacity, price);
  ``` 

  ```sql
  -- making query example for filtering on capacity and price
  explain analyze
  select *
  from room
  where capacity = 4
    and price < 100;
  
  -- Without index results:
  --
  -- Seq Scan on room  (cost=0.00..2214.22 rows=66 width=26) (actual time=104.757..104.761 rows=0 loops=1)
  --   Filter: ((price < 100) AND (capacity = 4))
  --   Rows Removed by Filter: 99015
  -- Planning Time: 3.237 ms
  -- Execution Time: 104.934 ms
  
  
  -- With index results:
  --
  -- Bitmap Heap Scan on room  (cost=4.97..205.07 rows=66 width=26) (actual time=4.968..4.973 rows=0 loops=1)
  --   Recheck Cond: ((capacity = 4) AND (price < 100))
  --   ->  Bitmap Index Scan on idx_rooms_capacity_price  (cost=0.00..4.95 rows=66 width=0) (actual time=4.952..4.954 rows=0 loops=1)
  --         Index Cond: ((capacity = 4) AND (price < 100))
  -- Planning Time: 16.722 ms
  -- Execution Time: 5.154 ms
  ```

- `idx_bookings_dates` - index for `booking` table on `start_date` and `end_date` columns
  > So often we need to find bookings in some date range.

  ```sql
  create index idx_bookings_dates on booking (start_date, end_date);
  ```

  ```sql
  -- making query example for fetching bookings in some date range
  explain analyze
  select *
  from booking
  where start_date > '2023-10-15'
    and end_date < '2023-10-19';
  
  -- Without index results:
  --
  -- Seq Scan on booking  (cost=0.00..591.50 rows=12 width=28) (actual time=15.395..15.408 rows=0 loops=1)
  --   Filter: ((start_date > '2023-10-15'::date) AND (end_date < '2023-10-20'::date))
  --   Rows Removed by Filter: 26433
  -- Planning Time: 16.281 ms
  -- Execution Time: 16.391 ms
  
  -- With index results:
  --
  -- Bitmap Heap Scan on booking  (cost=4.41..43.66 rows=12 width=28) (actual time=0.120..0.127 rows=0 loops=1)
  --   Recheck Cond: ((start_date > '2023-10-15'::date) AND (end_date < '2023-10-20'::date))
  --   ->  Bitmap Index Scan on idx_bookings_dates  (cost=0.00..4.41 rows=12 width=0) (actual time=0.104..0.107 rows=0 loops=1)
  --         Index Cond: ((start_date > '2023-10-15'::date) AND (end_date < '2023-10-20'::date))
  -- Planning Time: 0.988 ms
  -- Execution Time: 0.399 ms
  ```
