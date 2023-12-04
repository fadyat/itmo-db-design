begin transaction;

drop trigger if exists hotel_insert on hotel;

with data as (
    delete from hotels_pacific
        returning *)
insert
into hotel
select *
from data;

with data as (
    delete from hotels_mountain
        returning *)
insert
into hotel
select *
from data;

with data as (
    delete from hotels_central
        returning *)
insert
into hotel
select *
from data;

with data as (
    delete from hotels_eastern
        returning *)
insert
into hotel
select *
from data;

with data as (
    delete from hotels_others
        returning *)
insert
into hotel
select *
from data;

alter table room
    add constraint room_hotel_id_fkey
        foreign key (hotel_id) references hotel (id);

commit transaction;