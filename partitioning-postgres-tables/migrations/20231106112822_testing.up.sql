begin transaction;

insert into hotel
values (101, 'Grand Hotel', '(40.7577, -73.9877)', 'Luxury hotel in downtown', 1),
       (102, 'Seaside Resort', '(34.0522, -118.2437)', 'Beautiful resort on the coast', 1),
       (103, 'Mountain Lodge', '(40.0150, -105.2705)', 'Cozy lodge in the mountains', 1),
       (104, 'City View Inn', '(25.7617, -80.1918)', 'Affordable hotel with great city views', 1),
       (105, 'Riverside Retreat', '(38.6270, -90.1848)', 'Relaxing retreat by the river', 1),
       (106, 'Desert Oasis', '(33.4484, -112.0740)', 'Escape to the desert paradise', 1),
       (107, 'Historic Mansion Hotel', '(42.3601, -71.2082)', 'Stay in a beautifully restored mansion', 1),
       (108, 'Beachfront Paradise', '(20.7967, -156.4660)', 'Direct access to the sandy beach', 1),
       (109, 'Alpine Chalet', '(51.0447, -114.0719)', 'Cozy chalet in the alpine wilderness', 1),
       (110, 'Downtown Boutique', '(32.7157, -117.1611)', 'Charming boutique hotel in the heart of the city', 1),
       (111, 'Countryside Inn', '(43.1610, -77.6174)', 'Experience tranquility in the countryside', 1),
       (112, 'Lakeside Lodge', '(44.3148, -84.5194)', 'Enjoy serene lake views from your room', 2),
       (113, 'Tropical Hideaway', '(25.7617, -80.1918)', 'Escape to a tropical paradise', 1),
       (114, 'Mountaintop Retreat', '(34.0522, -118.2437)', 'Breathtaking views from the mountaintop', 1),
       (115, 'Urban Elegance Hotel', '(40.7577, -73.9877)', 'Elegant hotel in the heart of the city', 1);

explain analyze
insert into hotel
values (125, 'Urban Elegance Hotel', '(40.7577, -73.9877)', 'Elegant hotel in the heart of the city', 1);

explain analyze
select *
from hotel
where location[1] = -90.1848;

commit transaction;