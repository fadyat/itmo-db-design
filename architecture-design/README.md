## Design system like Booking

- Fadeyev Artyom M34021
- Making design of a https://booking.com

### Description

This system allows users to make reservations for rooms in hotel.

User select specific dates and location, and system shows available hotels with
rooms and their prices. Each room has a set of amenities.

After trip, user can leave a review for hotel, which affects total users rating
of hotel.

> Such system may have more features, but this is enough for core functionality.

### Entities

| Entity       | Description                                                                                     |
|--------------|-------------------------------------------------------------------------------------------------|
| user         | Represents a user of the hotel reservation system.                                              |
| user_contact | Stores user contact information.                                                                |
| hotel        | Base unit of the system, which contains of rooms.                                               |
| room         | Represents a room in hotel, accessible for booking.                                             |
| amenity      | Represents a room amenity, e.g. TV, WiFi, etc.                                                  |
| booking      | Represents a process of booking a room for some dates.                                          |
| review       | After trip, user can leave a review for his booking, which affects total users rating of hotel. |

### Design

![](./docs/design.png)

All tables are in 3NF, because of the following reasons:

- All tables are in 1NF, because each attribute contains only atomic values.
- All tables are in 2NF, because each non-prime attribute is fully functionally dependent on the primary key.
- All tables are in 3NF, because each non-prime attribute is non-transitively dependent on the primary key.
