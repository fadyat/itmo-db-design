begin transaction;

create or replace function on_hotels_insert()
    returns trigger as
$$
begin
    if (
                new.location[1] >= get_longitude('san-francisco') and
                new.location[1] < get_longitude('west-wendover')
        )
    then
        insert into hotels_pacific values (new.*);

    elsif (
                new.location[1] >= get_longitude('west-wendover') and
                new.location[1] < get_longitude('denver')
        )
    then
        insert into hotels_mountain values (new.*);

    elsif (
                new.location[1] >= get_longitude('denver') and
                new.location[1] < get_longitude('chicago')
        )
    then
        insert into hotels_central values (new.*);

    elsif (
                new.location[1] >= get_longitude('chicago') and
                new.location[1] < get_longitude('boston')
        )
    then
        insert into hotels_eastern values (new.*);

    else
        insert into hotels_others values (new.*);
    end if;

    return null;
end;
$$ language plpgsql;

create trigger hotel_insert
    before insert
    on hotel
    for each row
execute procedure on_hotels_insert();

commit transaction;