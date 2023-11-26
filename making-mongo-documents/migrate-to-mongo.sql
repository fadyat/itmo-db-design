-- structure of data will change because of migrating to a NoSQL database
-- because of it I will use joins in import queries

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

copy (
    select row_to_json(rows)
    from (select id,
                 name
          from amenity) rows
    ) to '/tmp/amenities.json' with (format text, header false);

copy (
    select row_to_json(rows)
    from (select id,
                 rating,
                 comment,
                 user_id,
                 booking_id
          from review) rows
    ) to '/tmp/reviews.json' with (format text, header false);



copy (
    select row_to_json(rows)
    from (with room_amenities as (select room_amenity.room_id as room_id,
                                         json_agg(
                                                 case
                                                     when amenity.id is null then null
                                                     else
                                                         json_build_object(
                                                                 'id', amenity.id,
                                                                 'name', amenity.name
                                                         )
                                                     end
                                         )                    as amenities
                                  from room_amenity
                                           left join amenity
                                                     on room_amenity.amenity_id = amenity.id
                                  group by room_amenity.room_id)
          select hotel.id,
                 hotel.name,
                 hotel.location,
                 hotel.description,
                 hotel.founder_id,
                 coalesce(json_agg(
                          case
                              when room.id is null then null
                              else
                                  json_build_object(
                                          'id', room.id,
                                          'name', room.name,
                                          'capacity', room.capacity,
                                          'price', room.price,
                                          'active', room.active
                                  )
                              end) filter ( where room.id is not null ), '[]'::json) as rooms
          from hotel
                   left join room
                             on hotel.id = room.hotel_id
                   left join room_amenities
                             on room.id = room_amenities.room_id
          group by hotel.id) rows
    ) to '/tmp/hotels.json' with (format text, header false);


copy (
    select row_to_json(rows)
    from (select id,
                 start_date,
                 end_date,
                 price,
                 status,
                 user_id,
                 room_id
          from booking) rows
    ) to '/tmp/bookings.json' with (format text, header false);

