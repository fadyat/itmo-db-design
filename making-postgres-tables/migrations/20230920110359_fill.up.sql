begin transaction;

insert into "user" (id, name, email, username, hashed_password)
values (1, 'admin', 'admin@localhost', 'admin', 'admin'),
       (2, 'aboba', 'aboba@localhost', 'aboba', 'aboba'),
       (3, 'user3', 'user3@localhost', 'user3', 'password3'),
       (4, 'user4', 'user4@localhost', 'user4', 'password4'),
       (5, 'user5', 'user5@localhost', 'user5', 'password5'),
       (6, 'user6', 'user6@localhost', 'user6', 'password6'),
       (7, 'user7', 'user7@localhost', 'user7', 'password7'),
       (8, 'user8', 'user8@localhost', 'user8', 'password8'),
       (9, 'user9', 'user9@localhost', 'user9', 'password9'),
       (10, 'user10', 'user10@localhost', 'user10', 'password10'),
       (11, 'user11', 'user11@localhost', 'user11', 'password11'),
       (12, 'user12', 'user12@localhost', 'user12', 'password12'),
       (13, 'user13', 'user13@localhost', 'user13', 'password13'),
       (14, 'user14', 'user14@localhost', 'user14', 'password14'),
       (15, 'user15', 'user15@localhost', 'user15', 'password15');

insert into user_contact (id, user_id, phone, address)
values (1, 1, '+78005553535', 'Saint-Petersburg'),
       (2, 2, '+15551234567', 'New York'),
       (3, 3, '+441234567890', 'London'),
       (4, 4, '+61234567890', 'Sydney'),
       (5, 5, '+81345678901', 'Tokyo'),
       (6, 6, '+491234567890', 'Berlin'),
       (7, 7, '+331234567890', 'Paris'),
       (8, 8, '+551234567890', 'Sao Paulo'),
       (9, 9, '+861234567890', 'Beijing'),
       (10, 10, '+911234567890', 'New Delhi'),
       (11, 11, '+12015551234', 'Los Angeles');

insert into hotel (id, name, location, description, founder_id)
values (1, 'Grand Hotel', '(40.7577, -73.9877)', 'Luxury hotel in downtown', 1),
       (2, 'Seaside Resort', '(34.0522, -118.2437)', 'Beautiful resort on the coast', 1),
       (3, 'Mountain Lodge', '(40.0150, -105.2705)', 'Cozy lodge in the mountains', 1),
       (4, 'City View Inn', '(25.7617, -80.1918)', 'Affordable hotel with great city views', 1),
       (5, 'Riverside Retreat', '(38.6270, -90.1848)', 'Relaxing retreat by the river', 1),
       (6, 'Desert Oasis', '(33.4484, -112.0740)', 'Escape to the desert paradise', 1),
       (7, 'Historic Mansion Hotel', '(42.3601, -71.2082)', 'Stay in a beautifully restored mansion', 1),
       (8, 'Beachfront Paradise', '(20.7967, -156.4660)', 'Direct access to the sandy beach', 1),
       (9, 'Alpine Chalet', '(51.0447, -114.0719)', 'Cozy chalet in the alpine wilderness', 1),
       (10, 'Downtown Boutique', '(32.7157, -117.1611)', 'Charming boutique hotel in the heart of the city', 1),
       (11, 'Countryside Inn', '(43.1610, -77.6174)', 'Experience tranquility in the countryside', 1),
       (12, 'Lakeside Lodge', '(44.3148, -84.5194)', 'Enjoy serene lake views from your room', 2),
       (13, 'Tropical Hideaway', '(25.7617, -80.1918)', 'Escape to a tropical paradise', 1),
       (14, 'Mountaintop Retreat', '(34.0522, -118.2437)', 'Breathtaking views from the mountaintop', 1),
       (15, 'Urban Elegance Hotel', '(40.7577, -73.9877)', 'Elegant hotel in the heart of the city', 1);

insert into amenity (id, name)
values (1, 'Swimming Pool'),
       (2, 'Fitness Center'),
       (3, 'Wi-Fi'),
       (4, 'Restaurant'),
       (5, 'Spa'),
       (6, 'Parking'),
       (7, 'Bar'),
       (8, 'Room Service'),
       (9, 'Conference Room'),
       (10, 'Laundry Service'),
       (11, 'Business Center'),
       (12, 'Pet-Friendly'),
       (13, 'Airport Shuttle'),
       (14, 'Concierge Service'),
       (15, 'Gym'),
       (16, 'Sauna');


insert into room (id, name, capacity, price, active, hotel_id)
values (1, 'Standard Room', 2, 100.00, true, 1),
       (2, 'Deluxe Room', 3, 150.00, true, 1),
       (3, 'Ocean View Suite', 2, 200.00, true, 1),
       (4, 'Mountain View Room', 2, 120.00, true, 1),
       (5, 'Executive Suite', 4, 250.00, true, 1),
       (6, 'Presidential Suite', 6, 500.00, true, 1),
       (7, 'Single Room', 1, 80.00, true, 1),
       (8, 'Double Room', 2, 120.00, true, 1),
       (9, 'Family Suite', 4, 180.00, true, 1),
       (10, 'Luxury Suite', 2, 300.00, true, 1),
       (11, 'Penthouse Suite', 4, 600.00, true, 1),
       (12, 'Lake View Room', 2, 130.00, true, 1),
       (13, 'Garden View Room', 2, 110.00, true, 1),
       (14, 'Poolside Cabana', 2, 175.00, false, 1),
       (15, 'Studio Apartment', 2, 140.00, true, 1);

insert into room_amenity (value, room_id, amenity_id)
values ('Parking available', 6, 6),
       ('+', 6, 5),
       ('+', 6, 7),
       ('+', 6, 8),
       ('Sauna access', 6, 16),
       ('Self Gym', 6, 15),
       ('Free Wi-Fi', 1, 3);

-- actual prices will be calculated in the next query
insert into booking (id, start_date, end_date, price, status, user_id, room_id)
values (1, '2023-09-25', '2023-09-30', 3000.00, 'approved', 2, 6),
       (2, '2023-10-05', '2023-10-10', 250.00, 'approved', 2, 2),
       (3, '2023-10-15', '2023-10-20', 400.00, 'pending', 3, 4),
       (4, '2023-10-18', '2023-10-22', 750.00, 'approved', 4, 5),
       (5, '2023-11-02', '2023-11-07', 150.00, 'rejected', 5, 8),
       (6, '2023-09-10', '2023-09-15', 300.00, 'approved', 6, 12),
       (7, '2023-10-20', '2023-10-25', 450.00, 'approved', 7, 10),
       (8, '2023-11-05', '2023-11-10', 200.00, 'rejected', 8, 7),
       (9, '2023-12-01', '2023-12-05', 600.00, 'pending', 9, 11),
       (10, '2023-12-10', '2023-12-15', 180.00, 'approved', 10, 9),
       (11, '2023-11-15', '2023-11-20', 700.00, 'approved', 11, 3),
       (12, '2023-10-25', '2023-10-30', 175.00, 'approved', 12, 14),
       (13, '2023-11-30', '2023-12-05', 350.00, 'pending', 13, 13),
       (14, '2023-12-15', '2023-12-20', 160.00, 'approved', 14, 15),
       (15, '2023-12-20', '2023-12-25', 800.00, 'pending', 15, 1);

update booking
set price = (end_date - start_date) * (select room.price
                                       from room
                                       where room.id = booking.room_id)
where true;

insert into review (id, rating, comment, user_id, booking_id)
values (1, 8, 'Great experience! Will definitely come back.', 1, 1),
       (2, 10, 'Exceptional service and room quality.', 2, 2),
       (3, 7, 'Nice view from the room, but the bed was too soft.', 3, 3),
       (4, 10, 'Loved the suite and the amenities!', 4, 4),
       (5, 5, 'Average experience, could use some improvements.', 5, 5),
       (6, 9, 'Beautiful lake view and cozy room.', 6, 6),
       (7, 8, 'Luxury at its finest! Great staff.', 7, 7),
       (8, 6, 'Bar service was slow, but room was nice.', 8, 8),
       (9, 9, 'Spacious suite, perfect for a family stay.', 9, 9),
       (10, 9, 'Stunning ocean view from the suite!', 10, 10),
       (11, 9, 'Relaxing poolside cabana experience.', 11, 12),
       (12, 9, 'Convenient airport shuttle service.', 12, 13),
       (13, 8, 'Cozy studio apartment with great amenities.', 13, 14),
       (14, 9, 'Excellent standard room, clean and comfortable.', 14, 15),
       (15, 7, 'Good value for the price, would recommend.', 15, 1);

-- path for CSV files is relative inside of the container
-- all migrations data is copied from the host machine to the container
-- via docker-compose volumes
copy amenity (id, name)
    from '/migrations/amenities.csv'
    delimiter ','
    CSV HEADER;

commit;