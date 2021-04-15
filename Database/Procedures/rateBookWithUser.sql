-- Rate book when user is logged in
-- procedure definition
delimiter //
create procedure rateBookWithUser(
    in userID int,
    in ISBN varchar(15),
    in rating int
)
begin
insert into rating values(ISBN, userID, rating);
end //
delimiter ;

-- call procedure
call rateBookWithUser(100, '123', 4);

-- drop procedure rateBookWithUser;