-- want to filter rooms by capacity and price
create index idx_rooms_capacity_price on room (capacity, price);

-- want to search bookings in some date range
create index idx_bookings_dates on booking (start_date, end_date);
