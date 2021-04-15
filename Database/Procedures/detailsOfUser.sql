-- Fetch Details of user
-- procedure definition
delimiter //
create procedure detailsOfUser(
    in userID int,
    out name varchar(50),
    out email varchar(70),
    out address varchar(500),
    out unpaidFines int
)
begin
select
user.name into name,
user.email into email,
user.address into address,
user.unpaidFines into unpaidFines
from user where user.userID = userID;
end //
delimiter ;

-- call procedure
call detailsOfUser(100, @name, @email, @address, @unpaidFines);
select @name;
select @email;
select @address;
select @unpaidFines;

-- drop procedure detailsOfUser;