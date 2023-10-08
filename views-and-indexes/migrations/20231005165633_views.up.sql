begin transaction;

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

commit transaction;