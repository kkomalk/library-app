-- 
-- procedure definition
delimiter //
create procedure removeFromFavourite(
    in userID int,
    in ISBN varchar(15)
)
begin
update readingList set readinList.favourite = 'NO' 
where readingList.userID = userID and readingList.ISBN = ISBN;
end //
delimiter ;

-- call procedure
call removeFromFavourite(100, '123');

-- drop procedure removeFromFavourite;