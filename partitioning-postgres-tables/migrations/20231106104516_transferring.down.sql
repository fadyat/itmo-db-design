begin transaction;

delete
from hotels_pacific;

delete
from hotels_mountain;

delete
from hotels_central;

delete
from hotels_eastern;

delete
from hotels_others;

commit transaction;