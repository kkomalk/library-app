-- Rate book when user is logged in
-- procedure definition
delimiter //
create procedure rateBookWithUser(
    in userID int,
    in ISBN varchar(15),
    in rating int
)
begin
declare ID int;
set ID = -1;
select rating.userID into ID from rating where rating.userID = userID and rating.ISBN = ISBN;
if(ID = -1) then
insert into rating(ISBN, userID, rating) values(ISBN, userID, rating);
else
update rating set rating.rating = rating where rating.userID = userID and rating.ISBN = ISBN;
end if;
end //
delimiter ;

-- call procedure
call rateBookWithUser(24, '123', 4);

-- drop procedure rateBookWithUser;