-- Fetch list of books read by user
-- procedure definition
delimiter //
create procedure listOfReadBooks(
    in userID int
)
begin
create table temp
select readingList.ISBN from readingList
where readingList.userID = userID and readingList.status = 'unread';
select temp.ISBN, book.title, book.yearOfPublication, book.authors
from temp inner join book
on temp.ISBN = book.ISBN;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfReadBooks(100);

-- drop procedure listOfReadBooks;