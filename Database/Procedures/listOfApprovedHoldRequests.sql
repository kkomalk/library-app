-- Fetch list of approved hold requests
-- procedure definition
delimiter //
create procedure listOfApprovedHoldRequests(
    in userID int
)
begin
create table temp
select bookCopiesUser.ISBN, bookCopiesUser.copyID, bookCopies.dueDate 
from bookCopiesUser inner join bookCopies 
on bookCopies.ISBN = bookCopiesUser.ISBN and bookCopies.copyID = bookCopiesUser.copyID
where bookCopiesUser.userID = userID
and bookCopiesUser.action != 'loan';
select temp.ISBN, temp.copyID, temp.dueDate, book.title, book.yearOfPublication, book.authors, book.category, book.image
from book inner join temp
on book.ISBN = temp.ISBN;
drop table temp;

end //
delimiter ;

-- call procedure
call listOfApprovedHoldRequests(14);

-- drop procedure listOfApprovedHoldRequests;