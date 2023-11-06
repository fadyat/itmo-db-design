Imaging we are having a startup in the USA area.

<img src="./docs/usa-timezones.png" alt="USA timezones" width="500"/>

We will partition our hotels table by the timezones.

### Create partitions

```sql
-- because of postgresql, we can't make optimal scan
-- of the table with the index on the column with the function
-- so we have to use the constant values instead of the function calls

begin transaction;

-- San-Francisco : 37.773972, -122.431297
-- West Wendover : 40.739097, -114.073345
create table hotels_pacific
(
    check (
                location[1] >= -122.431297 and
                location[1] < -114.073345
        )
) inherits (hotel);

...

commit;
```

### Trigger

```sql
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
```

### Transferring data

Done, by selecting data from the main table and inserting it into the partitioned tables.

### Analyze

```sql
explain analyze
insert into hotel
values (125, 'Urban Elegance Hotel', '(40.7577, -73.9877)', 'Elegant hotel in the heart of the city', 1);

--                                           QUERY PLAN                                           
-- -----------------------------------------------------------------------------------------------
--  Insert on hotel  (cost=0.00..0.01 rows=0 width=0) (actual time=31.185..31.190 rows=0 loops=1)
--    ->  Result  (cost=0.00..0.01 rows=1 width=1056) (actual time=0.018..0.023 rows=1 loops=1)
--  Planning Time: 0.483 ms
--  Trigger hotel_insert: time=30.554 calls=1
--  Execution Time: 31.472 ms
-- (5 rows)
```

```sql
explain analyze
select *
from hotel
where location[1] = -90.1848;

--                                                         QUERY PLAN                                                        
-- --------------------------------------------------------------------------------------------------------------------------
--  Append  (cost=0.00..10.88 rows=2 width=1056) (actual time=0.130..0.154 rows=1 loops=1)
--    ->  Seq Scan on hotel hotel_1  (cost=0.00..0.00 rows=1 width=1056) (actual time=0.043..0.044 rows=0 loops=1)
--          Filter: (location[1] = '-90.1848'::double precision)
--    ->  Seq Scan on hotels_central hotel_2  (cost=0.00..10.88 rows=1 width=1056) (actual time=0.075..0.080 rows=1 loops=1)
--          Filter: (location[1] = '-90.1848'::double precision)
--  Planning Time: 39.441 ms
--  Execution Time: 0.404 ms
-- (7 rows)
```
