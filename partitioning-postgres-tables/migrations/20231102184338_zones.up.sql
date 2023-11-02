begin transaction;

create table zones
(
    name      varchar(255) not null,
    longitude float8       not null
);

insert into zones
values ('san-francisco', -122.431297),
       ('west-wendover', -114.073345),
       ('denver', -104.991531),
       ('chicago', -87.623177),
       ('boston', -71.057083);

create function get_longitude(zone_name varchar)
    returns float8 as
$$
begin
    return (select longitude from zones where name = zone_name);
end;
$$ language plpgsql;

commit transaction;