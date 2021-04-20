-- Fetch list of books read by user
-- procedure definition
delimiter //
create procedure listOfReadBooks(
    in userID int
)
begin
create table temp
select readingList.ISBN, readingList.userID from readingList
where readingList.userID = userID and readingList.status = 'read';
select temp.ISBN, user.name, user.userID, book.title, book.yearOfPublication, book.authors, book.category, book.image
from temp inner join book inner join user
on temp.ISBN = book.ISBN and user.userID = temp.userID;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfReadBooks(4);

-- drop procedure listOfReadBooks;
