-- Details to be sent to user via email in case of overdue
delimiter //
create procedure emailDetails(
	in userID int,
    out unpaidFine int
)
begin
select user.unpaidFines into unpaidFine from user where user.userID = userID;
select book.ISBN, book.title, bookCopies.copyID, bookCopiesUser.action, bookCopies.dueDate
from book inner join bookCopies inner join bookCopiesUser
on book.ISBN = bookCopies.ISBN and bookCopies.ISBN = bookCopiesUser.ISBN and bookCopies.copyID = bookCopiesUser.copyID
where bookCopiesUser.userID = userID and bookCopies.dueDate < current_date(); 
end //
delimiter ;

-- call procedure
call emailDetails(24, @unpaidFine);
select @unpaidFine;

-- drop procedure emailDetails;