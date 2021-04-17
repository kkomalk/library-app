-- Issue book to user by librarian
-- procedure definition
delimiter //
create procedure issueBook(
    in userID int,
    in ISBN varchar(15),
    in copyID int,
    out success int,
    out dueDate date
)
a: begin
declare borrowed int;
declare userType varchar(20);
declare bookAction varchar(20);
declare loanLimit int;
declare unpaidFine int;
select count(bookCopiesUser.ISBN) into borrowed from bookCopiesUser
where bookCopiesUser.userID = userID and bookCopiesUser.action != 'hold';
select user.unpaidFines into unpaidFine from user where user.userID = userID;
select account.accountType into userType from account where account.accountID = userID;
if(userType = 'student' and borrowed > 2) then
    set success = 0;
    set dueDate = NULL;
    leave a;
elseif(userType = 'professor' and borrowed > 4) then
    set success = 0;
    set dueDate = NULL;
    leave a;
elseif(unpaidFine > 1000) then
    set success = 0;
    set dueDate = NULL;
    leave a;
end if;
if(userType = 'student') then
    set loanLimit = 30;
elseif(userType = 'professor') then
    set loanLimit = 60;
end if;
select bookCopiesUser.action into bookAction from bookCopiesUser
where bookCopiesUser.userID = userID and bookCopiesUser.ISBN = ISBN and bookCopiesUser.copyID = copyID;
if(bookAction = 'loan&hold') then
	call returnBook(userID, ISBN, copyID);
    update book set book.noOfCopiesOnShelf = book.noOfCopiesOnShelf - 1
    where book.ISBN = ISBN;
    update bookCopies set bookCopies.bookStatus = 'loan', bookCopies.dueDate = date_add(current_date(), interval loanLimit day)
    where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
    insert into bookCopiesUser values(ISBN, copyID, userID, 'loan');
    set success = 1;
    set dueDate = date_add(current_date(), interval loanLimit day);
elseif(bookAction = 'hold') then
    update bookCopies set bookCopies.bookStatus = 'loan', bookCopies.dueDate = date_add(current_date(), interval loanLimit day)
    where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
    update bookCopiesUser set bookCopiesUser.action = 'loan' where bookCopiesUser.userID = userID and
    bookCopiesUser.ISBN = ISBN and bookCopiesUser.copyID = copyID;
    set success = 1;
    set dueDate = date_add(current_date(), interval loanLimit day);
elseif(bookAction = 'loan') then
    set success = 0;
    set dueDate = NULL;
else 
    update book set book.noOfCopiesOnShelf = book.noOfCopiesOnShelf - 1
    where book.ISBN = ISBN;
    update bookCopies set bookCopies.bookStatus = 'loan', bookCopies.dueDate = date_add(current_date(), interval loanLimit day)
    where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
    insert into bookCopiesUser values(ISBN, copyID, userID, 'loan');
    set success = 1;
    set dueDate = date_add(current_date(), interval loanLimit day);
end if; 
end //
delimiter ;

-- call procedure
call issueBook(4, '123', 1, @success, @dueDate);
select @success;
select @dueDate;
-- success = 0 : Can't be issued due to limits
-- success = 1 : Book issued succesfully

-- drop procedure issueBook;