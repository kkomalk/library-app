-- Cancel hold if due Date is crossed
delimiter //
create procedure cancelHold(
	in ISBN varchar(15),
    in copyID int,
    out status int
)
begin
declare dueDate date;
declare bookStatus varchar(20);
set bookstatus = 'Hello';
set status = 0;
select bookCopies.dueDate into dueDate from bookCopies where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
select bookCopies.bookStatus into bookStatus from bookCopies where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
if(bookStatus = 'hold' and current_date() > dueDate) then
	delete from bookCopiesUser where bookCopiesUser.ISBN = ISBN and bookCopiesUser.copyID = copyID and bookCopiesUser.action = 'hold';
    update bookCopies set bookCopies.bookStatus = 'shelf' where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
    update book set book.noOfCopiesOnShelf = book.noOfCopiesOnShelf + 1 where book.ISBN = ISBN; 
	set status = 1;
end if;
end //
delimiter ;

-- call procedure
call cancelHold('123', 1, @status);
select @status;
-- status = 0 : No action taken
-- status = 1 : Hold revoked

-- drop procedure cancelHold;
