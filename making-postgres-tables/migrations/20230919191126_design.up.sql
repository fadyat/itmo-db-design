create table "user"
(
    id              int primary key,
    name            varchar(255) not null,
    email           varchar(255) not null,
    username        varchar(255) not null,
    hashed_password varchar(255) not null,

    unique (email),
    unique (username)
);

create table user_contact
(
    id      int primary key,
    user_id int references "user" (id) not null,
    phone   varchar(20)                not null,
    address varchar(255)               not null,

    unique (user_id)
);


create table hotel
(
    id          int primary key,
    name        varchar(255)               not null,
    location    point                      not null,
    description varchar(1024),

    founder_id  int references "user" (id) not null
);

create table room
(
    id       int primary key,
    name     varchar(255)              not null,
    capacity int                       not null,
    price    int                       not null,
    active   boolean default true      not null,

    hotel_id int references hotel (id) not null,

    check ( capacity > 0 ),
    check ( price > 0 )
);

create table amenity
(
    id   int primary key,
    name varchar(255) not null,

    unique (name)
);

create table room_amenity
(
    value      varchar(255)                not null,
    room_id    int references room (id)    not null,
    amenity_id int references amenity (id) not null,

    primary key (room_id, amenity_id)
);


create type booking_status as enum ('pending', 'approved', 'rejected');

create table booking
(
    id         int primary key,
    start_date date                       not null,
    end_date   date                       not null,

    -- price is a total price for [start_date, end_date] period
    -- room.price can be changed is some period, but price in booking should always be fixed
    price      int                        not null,
    status     booking_status default 'pending',

    user_id    int references "user" (id) not null,
    room_id    int references room (id)   not null,

    check ( start_date < end_date ),
    check ( status in ('pending', 'approved', 'rejected') )
);

create table review
(
    id         int primary key,
    rating     int                         not null,
    comment    varchar(1024)               not null,

    user_id    int references "user" (id)  not null,
    booking_id int references booking (id) not null,

    check (rating between 1 and 10)
);