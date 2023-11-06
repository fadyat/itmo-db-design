begin transaction;

alter table hotels_pacific
    no inherit hotel;

alter table hotels_mountain
    no inherit hotel;

alter table hotels_central
    no inherit hotel;

alter table hotels_eastern
    no inherit hotel;

alter table hotels_others
    no inherit hotel;

insert into hotels_pacific
select *
from hotel
where location[1] >= get_longitude('san-francisco')
  and location[1] < get_longitude('west-wendover');


insert into hotels_mountain
select *
from hotel
where location[1] >= get_longitude('west-wendover')
  and location[1] < get_longitude('denver');

insert into hotels_central
select *
from hotel
where location[1] >= get_longitude('denver')
  and location[1] < get_longitude('chicago');

insert into hotels_eastern
select *
from hotel
where location[1] >= get_longitude('chicago')
  and location[1] < get_longitude('boston');

insert into hotels_others
select *
from hotel
where location[1] >= get_longitude('boston')
   or location[1] < get_longitude('san-francisco');


-- done only for testing issues, not for production
-- removing all the data from the hotel table and related tables
--
-- current query is not rolled back
truncate hotel cascade;

alter table hotels_pacific
    inherit hotel;

alter table hotels_mountain
    inherit hotel;

alter table hotels_central
    inherit hotel;

alter table hotels_eastern
    inherit hotel;

alter table hotels_others
    inherit hotel;

commit transaction;