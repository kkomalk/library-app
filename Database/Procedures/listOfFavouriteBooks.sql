-- List of Favourite Books of an user
-- procedure definition
delimiter //
create procedure listOfFavouriteBooks(
    in userID int
)
begin
create table temp
select readingList.ISBN from readingList where readingList.userID = userID;
select temp.ISBN, book.title, book.yearOfPublication, book.authors 
from temp inner join book
on book.ISBN = temp.ISBN;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfFavouriteBooks(100);

-- drop procedure listOfFavouriteBooks;