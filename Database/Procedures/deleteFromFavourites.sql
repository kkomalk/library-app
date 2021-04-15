-- delete a book from favourite list
-- procedure definition
delimiter //
create procedure deleteFromFavourites(
    in userID int,
    in ISBN varchar(15)
)
begin
delete from readingList where readingList.userID = userID and readingList.ISBN = ISBN;
end //
delimiter ;

-- call procedure
call deleteFromFavourites(100, '123');

-- drop procedure deleteFromFavourites;