begin transaction;

drop table if exists hotels_pacific;
drop table if exists hotels_mountain;
drop table if exists hotels_central;
drop table if exists hotels_eastern;
drop table if exists hotels_others;

commit transaction;