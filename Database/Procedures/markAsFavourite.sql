-- Mark a book as favourite
-- procedure definition
delimiter //
create procedure markAsFavourite(
    in userID int,
    in ISBN varchar(15),
    in readBook int
)
begin
if(readBook = 1) then
    insert into readingList values(ISBN, userID, 'read', 'YES');
else
    insert into readingList values(ISBN, userID, 'unread', 'YES');
end if;
end //
delimiter ;

-- call procedure
call markAsFavourite(4, '123', 1);

-- drop procedure markAsFavourite;
