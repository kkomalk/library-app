-- Mark a book as favourite
-- procedure definition
delimiter //
create procedure markAsFavourite(
    in userID int,
    in ISBN varchar(15),
    in read int
)
begin
if(read = 1) then
    insert into readingList values(userID, ISBN, 'read', 'YES');
else
    insert into readingList values(userID, ISBN, 'unread', 'YES');
end if;
end //
delimiter ;

-- call procedure
call markAsFavourite(100, '123', 1);

-- drop procedure markAsFavourite;