-- Fetch list of active hold requests
-- procedure definition
delimiter //
create procedure listOfActiveHoldRequests(
    in userID int
)
begin
create table temp
select holdRequest.ISBN from holdRequest where holdRequest.userID = userID;
select temp.ISBN, book.title, book.yearOfPublication, book.authors, book.category, book.image
from temp inner join book
on temp.ISBN = book.ISBN;
drop table temp;
end //
delimiter ;

-- call procedure
call listOfActiveHoldRequests(4);

-- drop procedure listOfActiveHoldRequests;