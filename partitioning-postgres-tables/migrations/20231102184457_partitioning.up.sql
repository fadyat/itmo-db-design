-- because of postgresql, we can't make optimal scan
-- of the table with the index on the column with the function
-- so we have to use the constant values instead of the function calls

begin transaction;

-- San-Francisco : 37.773972, -122.431297
-- West Wendover : 40.739097, -114.073345
create table hotels_pacific
(
    check (
--                 location[1] >= get_longitude('san-francisco') and
--                 location[1] < get_longitude('west-wendover')
                location[1] >= -122.431297 and
                location[1] < -114.073345
        )
) inherits (hotel);

-- West Wendover : 40.739097, -114.073345
-- Denver        : 39.742043, -104.991531
create table hotels_mountain
(
    check (
--                 location[1] >= get_longitude('west-wendover') and
--                 location[1] < get_longitude('denver')
                location[1] >= -114.073345 and
                location[1] < -104.991531
        )
) inherits (hotel);

-- Denver  : 39.742043, -104.991531
-- Chicago : 41.881832, -87.623177
create table hotels_central
(
    check (
--                 location[1] >= get_longitude('denver') and
--                 location[1] < get_longitude('chicago')
                location[1] >= -104.991531 and
                location[1] < -87.623177
        )
) inherits (hotel);

-- Chicago : 41.881832, -87.623177
-- Boston  : 42.361145, -71.057083
create table hotels_eastern
(
    check (
--                 location[1] >= get_longitude('chicago') and
--                 location[1] < get_longitude('boston')
                location[1] >= -87.623177 and
                location[1] < -71.057083
        )
) inherits (hotel);


-- Boston        : 42.361145, -71.057083
-- San-Francisco : 37.773972, -122.431297
create table hotels_others
(
    check (
--                 location[1] >= get_longitude('boston') or
--                 location[1] < get_longitude('san-francisco')
                location[1] >= -71.057083 or
                location[1] < -122.431297
        )
) inherits (hotel);

commit transaction;
