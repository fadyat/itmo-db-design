-- making query example for filtering on capacity and price
explain analyze
select *
from room
where capacity = 4
  and price < 100;

-- Without index results:
--
-- Seq Scan on room  (cost=0.00..2214.22 rows=66 width=26) (actual time=104.757..104.761 rows=0 loops=1)
--   Filter: ((price < 100) AND (capacity = 4))
--   Rows Removed by Filter: 99015
-- Planning Time: 3.237 ms
-- Execution Time: 104.934 ms


-- With index results:
--
-- Bitmap Heap Scan on room  (cost=4.97..205.07 rows=66 width=26) (actual time=4.968..4.973 rows=0 loops=1)
--   Recheck Cond: ((capacity = 4) AND (price < 100))
--   ->  Bitmap Index Scan on idx_rooms_capacity_price  (cost=0.00..4.95 rows=66 width=0) (actual time=4.952..4.954 rows=0 loops=1)
--         Index Cond: ((capacity = 4) AND (price < 100))
-- Planning Time: 16.722 ms
-- Execution Time: 5.154 ms


-- making query example for fetching bookings in some date range
explain analyze
select *
from booking
where start_date > '2023-10-15'
  and end_date < '2023-10-19';

-- Without index results:
--
-- Seq Scan on booking  (cost=0.00..591.50 rows=12 width=28) (actual time=15.395..15.408 rows=0 loops=1)
--   Filter: ((start_date > '2023-10-15'::date) AND (end_date < '2023-10-20'::date))
--   Rows Removed by Filter: 26433
-- Planning Time: 16.281 ms
-- Execution Time: 16.391 ms

-- With index results:
--
-- Bitmap Heap Scan on booking  (cost=4.41..43.66 rows=12 width=28) (actual time=0.120..0.127 rows=0 loops=1)
--   Recheck Cond: ((start_date > '2023-10-15'::date) AND (end_date < '2023-10-20'::date))
--   ->  Bitmap Index Scan on idx_bookings_dates  (cost=0.00..4.41 rows=12 width=0) (actual time=0.104..0.107 rows=0 loops=1)
--         Index Cond: ((start_date > '2023-10-15'::date) AND (end_date < '2023-10-20'::date))
-- Planning Time: 0.988 ms
-- Execution Time: 0.399 ms