-- List of Favourite Books of an user
-- procedure definition
delimiter //
create procedure listOfFavouriteBooks(
    in userID int
)
begin
create table temp
select readingList.ISBN, readingList.userID from readingList where readingList.userID = userID and readingList.favourite = 'YES';
select temp.ISBN, user.name, book.title, book.yearOfPublication, book.authors, book.category, book.image 
from temp inner join book inner join user
on book.ISBN = temp.ISBN and temp.userID = user.userID;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfFavouriteBooks(4);

-- drop procedure listOfFavouriteBooks;
