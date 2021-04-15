-- Rate book when user is not logged in
-- procedure definition
delimiter //
create procedure rateBookWithoutUser(
    in ISBN varchar(15),
    in rating int
)
begin
insert into rating values(ISBN, NULL, rating);
end //
delimiter ;

-- call procedure
call rateBookWithoutUser('123', 5);

-- drop procedure rateBookWithoutUser;