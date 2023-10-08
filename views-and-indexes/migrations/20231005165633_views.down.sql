begin transaction;

drop view if exists room_with_amenities;
drop view if exists hotel_with_rating;

commit transaction;