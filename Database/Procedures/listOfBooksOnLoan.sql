-- Fetch list of books on loan for a user
-- procedure definition
delimiter //
create procedure listOfBooksOnLoan(
    in userID int
)
begin
create table temp
select bookCopiesUser.ISBN, bookCopiesUser.copyID
from bookCopiesUser
where bookCopiesUser.userID = userID
and bookCopiesUser.action != 'hold';
select temp.ISBN, temp.copyID, book.title, book.yearOfPublication, book.authors, book.category, book.image 
from temp inner join book
on book.ISBN = temp.ISBN;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfBooksOnLoan(4);

-- drop procedure listOfBooksOnLoan;