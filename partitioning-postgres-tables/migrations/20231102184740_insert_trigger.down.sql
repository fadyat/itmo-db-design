begin transaction;

drop trigger if exists hotel_insert on hotel;
drop routine if exists on_hotels_insert;

commit transaction;