begin transaction;


alter table room
    drop constraint if exists room_hotel_id_fkey;

with data as (
    delete from only hotel
        where location[1] >= get_longitude('san-francisco')
            and location[1] < get_longitude('west-wendover')
        returning *)
insert
into hotels_pacific
select *
from data;

with data as (
    delete from only hotel
        where location[1] >= get_longitude('west-wendover')
            and location[1] < get_longitude('denver')
        returning *)
insert
into hotels_mountain
select *
from data;

with data as (
    delete from only hotel
        where location[1] >= get_longitude('denver')
            and location[1] < get_longitude('chicago')
        returning *)
insert
into hotels_central
select *
from data;

with data as (
    delete from only hotel
        where location[1] >= get_longitude('chicago')
            and location[1] < get_longitude('boston')
        returning *)
insert
into hotels_eastern
select *
from data;

with data as (
    delete from only hotel
        where location[1] >= get_longitude('boston')
            or location[1] < get_longitude('san-francisco')
        returning *)
select *
from data;

commit transaction;