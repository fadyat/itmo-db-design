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

begin transaction;

-- let's hide some bookings information
create materialized view generalized_bookings as
select id,
       anon.generalize_daterange(start_date, 'month') as start_date,
       anon.generalize_daterange(end_date, 'month')   as end_date,
       anon.generalize_numrange(price, 100)           as price,
       status,
       user_id
from booking;

commit transaction;


begin transaction;

-- let's create a materialized view with pseudonymized data
-- and partially masked username
create materialized view pseudonymization_users as
select id,
       anon.pseudo_first_name(name)           as name,
       anon.pseudo_email(email)               as email,
       anon.partial(username, 1, $$xxxx$$, 2) as username
from "user";

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

commit transaction;