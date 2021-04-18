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
select rating.userID into ID from rating where rating.userID = userID and rating.ISBN = ISBN;
if(ID = NULL) then
insert into rating(ISBN, userID, rating) values(ISBN, userID, rating);
else
update rating set rating.rating = rating where rating.userID = userID and rating.ISBN = ISBN;
end if;
end //
delimiter ;

-- call procedure
call rateBookWithUser(4, '123', 5);

-- drop procedure rateBookWithUser;