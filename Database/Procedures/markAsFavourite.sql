-- Mark a book as favourite
-- procedure definition
delimiter //
create procedure markAsFavourite(
    in userID int,
    in ISBN varchar(15),
    in readBook int
)
begin
declare fav varchar(3);
set fav = '';
select readingList.favourite into fav from readingList where readingList.userID = userID and readingList.ISBN = ISBN;
if(fav != '') then
	update readingList set readingList.favourite = 'YES' where readingList.userID = userID and readingList.ISBN = ISBN;
else
	if(readBook = 1) then
		insert into readingList values(ISBN, userID, 'read', 'YES');
	else
		insert into readingList values(ISBN, userID, 'unread', 'YES');
	end if;
end if;
end //
delimiter ;

-- call procedure
call markAsFavourite(4, '123', 1);

-- drop procedure markAsFavourite;
