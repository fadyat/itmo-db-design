begin transaction;

-- San-Francisco : 37.773972, -122.431297
-- West Wendover : 40.739097, -114.073345
create table hotels_pacific
(
    check (
                location[1] >= get_longitude('san-francisco') and
                location[1] < get_longitude('west-wendover')
        )
) inherits (hotel);

-- West Wendover : 40.739097, -114.073345
-- Denver        : 39.742043, -104.991531
create table hotels_mountain
(
    check (
                location[1] >= get_longitude('west-wendover') and
                location[1] < get_longitude('denver')
        )
) inherits (hotel);

-- Denver  : 39.742043, -104.991531
-- Chicago : 41.881832, -87.623177
create table hotels_central
(
    check (
                location[1] >= get_longitude('denver') and
                location[1] < get_longitude('chicago')
        )
) inherits (hotel);

-- Chicago : 41.881832, -87.623177
-- Boston  : 42.361145, -71.057083
create table hotels_eastern
(
    check (
                location[1] >= get_longitude('chicago') and
                location[1] < get_longitude('boston')
        )
) inherits (hotel);


-- Boston        : 42.361145, -71.057083
-- San-Francisco : 37.773972, -122.431297
create table hotels_others
(
    check (
                location[1] >= get_longitude('boston') and
                location[1] < get_longitude('san-francisco')
        )
) inherits (hotel);

commit transaction;
