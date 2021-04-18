-- Remove book from favourites
-- procedure definition
delimiter //
create procedure removeFromFavourite(
    in userID int,
    in ISBN varchar(15)
)
begin
update readingList set readingList.favourite = 'NO' 
where readingList.userID = userID and readingList.ISBN = ISBN;
end //
delimiter ;

-- call procedure
call removeFromFavourite(4, '123');

-- drop procedure removeFromFavourite;