-- Fetch list of books on loan for a user
-- procedure definition
delimiter //
create procedure listOfBooksOnLoan(
    in userID int
)
begin
create table temp
select bookCopiesUser.ISBN, bookCopiesUser.copyID, bookCopies.dueDate
from bookCopiesUser inner join bookCopies 
on bookCopies.ISBN = bookCopiesUser.ISBN and bookCopies.copyID = bookCopiesUser.copyID
where bookCopiesUser.userID = userID
and bookCopiesUser.action != 'hold';
select temp.ISBN, temp.copyID, temp.dueDate, book.title, book.yearOfPublication, book.authors, book.category, book.image 
from temp inner join book
on book.ISBN = temp.ISBN;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfBooksOnLoan(4);

-- drop procedure listOfBooksOnLoan;