-- Fetch list of approved hold requests
-- procedure definition
delimiter //
create procedure listOfApprovedHoldRequests(
    in userID int
)
begin
create table temp
select bookCopiesUser.ISBN, bookCopiesUser.copyID 
from bookCopiesUser where bookCopiesUser.userID = userID
and bookCopiesUser.action != 'loan';
select temp.ISBN, temp.copyID, book.title, book.yearOfPublication, book.authors
from book inner join temp
on book.ISBN = temp.ISBN;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfApprovedHoldRequests(100);

-- drop procedure listOfApprovedHoldRequests;