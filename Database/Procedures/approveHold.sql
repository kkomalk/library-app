-- Approve hold request of a user for a book
-- procedure definition
delimiter //
create procedure approveHold(
    in userID int,
    in ISBN varchar(15),
    out copyID int,
    out dueDate date,
    out status int
)
begin
declare cid int;
declare bookCount int;
declare action varchar(20);
declare minCopyID int;
declare userType varchar(20);
declare holdLimit int;
declare loanLimit int;
declare noOfCopiesOnShelf int;

select bookCopiesUser.action into action from bookCopiesUser
where bookCopiesUser.userID = userID and bookCopiesUser.ISBN = ISBN;
select account.accountType into userType from account where account.accountID = userID;
if(userType = 'student') then
    set holdLimit = 10;
    set loanLimit = 30;
elseif(userType = 'professor') then
    set holdLimit = 20;
    set loanLimit = 60;
end if;

if(action = 'loan') then
    select bookCopiesUser.copyID into minCopyID from bookCopiesUser
    where bookCopiesUser.userID = userID and bookCopiesUser.ISBN = ISBN;
    update bookCopies set bookCopies.bookStatus = 'loan&hold', 
    bookCopies.dueDate = date_add(current_date(), interval loanLimit day)
    where bookCopies.ISBN = ISBN and bookCopies.copyID = minCopyID;
    update bookCopiesUser set bookCopiesUser.action = 'loan&hold'
    where bookCopiesUser.userID = userID and bookCopiesUser.ISBN = ISBN and bookCopiesUser.copyID = minCopyID;
    delete from holdRequest where holdRequest.userID = userID and holdRequest.ISBN = ISBN;
    set status = 1;
    set copyID = minCopyID;
    set dueDate = date_add(current_date(), interval loanLimit day);
else
    select count(bookCopies.copyID) into bookCount from bookCopies
    where bookCopies.ISBN = ISBN and bookCopies.bookStatus = 'shelf';

    if(bookCount > 0) then
        select min(bookCopies.copyID) into minCopyID from bookCopies
        where bookCopies.ISBN = ISBN and bookCopies.bookStatus = 'shelf';
        update bookCopies set bookCopies.bookStatus = 'hold', bookCopies.dueDate = date_add(current_date(), interval loanLimit day)
        where bookCopies.ISBN = ISBN and bookCopies.copyID = minCopyID;
        insert into bookCopiesUser values(ISBN, minCopyID, userID, 'hold');
        delete from holdRequest where holdRequest.userID = userID and holdRequest.ISBN = ISBN;
        select count(bookCopies.copyID) into noOfCopiesOnShelf from bookCopies
        where bookCopies.bookStatus = 'shelf' and bookCopies.ISBN = ISBN;
        update book set book.noOfCopiesOnShelf = noOfCopiesOnShelf where book.ISBN = ISBN; 
        set status = 1;
        set copyID = minCopyID;
        set dueDate = date_add(current_date(), interval loanLimit day);
    else
        set status = 0;
        set copyID = NULL;
        set dueDate = NULL;
    end if;
end if;
end //
delimiter ;

-- call procedure
call approveHold(4, '123', @copyID, @dueDate, @status);
select @status;
select @copyID;
select @dueDate;
-- status = 0 : Book unavailable
-- status = 1 : Hold request approved

-- drop procedure approveHold;

