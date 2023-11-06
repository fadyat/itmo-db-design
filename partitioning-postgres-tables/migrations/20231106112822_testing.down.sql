begin transaction;

delete
from hotels_central
where id > 100
  and id <= 125;

delete
from hotels_eastern
where id > 100
  and id <= 125;

delete
from hotels_mountain
where id > 100
  and id <= 125;

delete
from hotels_pacific
where id > 100
  and id <= 125;

delete
from hotels_others
where id > 100
  and id <= 125;

commit transaction;