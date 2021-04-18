-- Rate book when user is logged in
-- procedure definition
delimiter //
create procedure rateBookWithUser(
    in userID int,
    in ISBN varchar(15),
    in rating int
)
begin
insert into rating(ISBN, userID, rating) values(ISBN, userID, rating);
end //
delimiter ;

-- call procedure
call rateBookWithUser(4, '123', 5);

-- drop procedure rateBookWithUser;