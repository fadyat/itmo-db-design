## Masking data in PostgreSQL

- Fadeyev Artyom M34021
- Making design of a https://booking.com
- PostgreSQL as a DB

### Dynamic masking

```sql
begin transaction;

-- activate the masking extension
create extension if not exists anon cascade;
select anon.start_dynamic_masking();

-- declaring a masked user
create role masked_user login password 'postgres';
security label for anon on role masked_user is 'MASKED';

-- declaring the masking rules
security label for anon on column "user".name
    is 'MASKED WITH FUNCTION anon.fake_last_name()';
security label for anon on column user_contact.phone
    IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$******$$,2)';

commit;
```

Connecting to the database as a masked user:

```bash
docker exec -it making-postgres-tables_psql_1 /bin/bash -c "psql -U masked_user -d postgres"
```

Let's verify, that user name is masked:

```sql
select * from "user" order by id limit 5;
 
-- id |   name   |      email      | username | hashed_password 
-- ----+----------+-----------------+----------+-----------------
--  1 | Nienow   | admin@localhost | admin    | admin
--  2 | Donnelly | aboba@localhost | aboba    | aboba
--  3 | Dickens  | user3@localhost | user3    | password3
--  4 | O'Keefe  | user4@localhost | user4    | password4
--  5 | Tillman  | user5@localhost | user5    | password5
-- (5 rows)

select * from "user" order by id limit 5;

-- id |   name   |      email      | username | hashed_password 
-- ----+----------+-----------------+----------+-----------------
--  1 | Okuneva  | admin@localhost | admin    | admin
--  2 | Hammes   | aboba@localhost | aboba    | aboba
--  3 | Smitham  | user3@localhost | user3    | password3
--  4 | O'Reilly | user4@localhost | user4    | password4
--  5 | West     | user5@localhost | user5    | password5
```

### Generalization

The idea of generalization is to replace data with broader and less accurate values, ranges.

We want the anonymized data to remain true because it will be used for statistics.

We can build a view upon this table to remove useless columns and generalize the indirect identifiers

```sql
-- let's hide some bookings information
create materialized view generalized_bookings as
select id,
       anon.generalize_daterange(start_date, 'month') as start_date,
       anon.generalize_daterange(end_date, 'month')   as end_date,
       anon.generalize_numrange(price, 100)           as price,
       status,
       user_id
from booking;
```

Let's check the result:

```sql
select * from generalized_bookings limit 5;

-- id |       start_date        |        end_date         |    price    |  status  | user_id  
-- ----+-------------------------+-------------------------+-------------+----------+--------
--  1 | [2023-09-01,2023-10-01) | [2023-09-01,2023-10-01) | [2500,2600) | approved |       2 
--  2 | [2023-10-01,2023-11-01) | [2023-10-01,2023-11-01) | [700,800)   | approved |       2 
--  3 | [2023-10-01,2023-11-01) | [2023-10-01,2023-11-01) | [600,700)   | pending  |       3 
--  4 | [2023-10-01,2023-11-01) | [2023-10-01,2023-11-01) | [1000,1100) | approved |       4 
--  5 | [2023-11-01,2023-12-01) | [2023-11-01,2023-12-01) | [600,700)   | rejected |       5 
```

### Various Masking Strategies

- **Pseudonymization**

  Replaces the original data with a pseudonym, which is a value that looks like a real value but is not.

    ```sql
    -- let's create a materialized view with pseudonymized data
    -- and partially masked username
    create materialized view pseudonymization_users as
    select id,
           anon.pseudo_first_name(name)           as name,
           anon.pseudo_email(email)               as email,
           anon.partial(username, 1, $$xxxx$$, 2) as username
    from "user";
    ```

    ```sql
    select * from pseudonymization_users limit 5;
    
    -- id |  name   |           email           | username 
    -- ----+---------+---------------------------+----------
    --  1 | Gertie  | robert41@hughes.com       | axxxxin
    --  2 | Lugenia | kellykimberly@smith.com   | axxxxba
    --  3 | Marland | trevor48@gmail.com        | uxxxxr3
    --  4 | Fae     | hrichardson@yahoo.com     | uxxxxr4
    --  5 | Dante   | david01@nguyen-miller.org | uxxxxr5
    ```

- **Faking**

  ```sql
  -- custom function to generate fake phone numbers
  create function anon.fake_phone() returns text as
  $$
  begin
      return '+' || lpad((random() * 10000000000)::bigint::varchar, 10, '0');
  end;
  $$ language plpgsql;
  
  -- using faking techniques to generate fake data
  create materialized view faked_user_contacts as
  select id,
         user_id,
         anon.fake_phone()   as phone,
         anon.fake_address() as address
  from user_contact;
  ```
  
  ```sql
  select * from faked_user_contacts limit 5;
  
  --  id | user_id |    phone    |                          address                          
  -- ----+---------+-------------+-----------------------------------------------------------
  --   1 |       1 | +6111019964 | 2249 Brandon Freeway Apt. 684, West Anthonyberg, CT 00662
  --   2 |       2 | +7219243561 | 689 Wiley Hill, South Patricia, RI 07445
  --   3 |       3 | +8269829795 | Unit 0342 Box 2288, DPO AE 91483
  --   4 |       4 | +4866410958 | 07910 Scott Island Apt. 514, North Aprilport, SD 19662
  --   5 |       5 | +7641590937 | 4576 Scott Mews Apt. 324, West Thomasmouth, IA 60794
  ```


