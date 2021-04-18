-- Update unpaid Fine for a user
-- procedure definition
delimiter //
create procedure updateFine(
    in userID int
)
begin
declare noOfDelayedReturns int;
declare totalFine int;
create table temp
select bookCopiesUser.userID, bookCopiesUser.ISBN, bookCopiesUser.copyID, bookCopies.dueDate
from bookCopies inner join bookCopiesUser on
bookCopies.ISBN = bookCopiesUser.ISBN and bookCopies.copyID = bookCopiesUser.copyID
where bookCopiesUser.userID = userID and bookCopiesUser.action != 'hold' and bookCopies.dueDate > current_date();
update temp set temp.userID = datediff(current_date(), dueDate);
select sum(temp.userID) into totalFine from temp;
set totalFine = totalFine * 2;
if(totalFine != NULL) then
update user set user.unpaidFines = totalFine where user.userID = userID;
end if;
drop table temp;
end //
delimiter ;

-- call procedure
call updateFine(4);

-- drop procedure updateFine;