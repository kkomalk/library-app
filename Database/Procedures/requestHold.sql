-- Request to put hold on a boook by a user
-- procedure definition
delimiter //
create procedure requestHold(
    in userID int,
    in ISBN varchar(15),
    out status int
)
begin
-- Declare Variables
declare cid int;
declare size1 int;
declare size2 int;
declare holdLimit1 int;
declare holdLimit2 int;
declare unpaidFine int;
declare userType varchar(20);

-- Check if user is trying for loan and hold
select bookCopiesUser.copyID into cid from bookCopiesUser
where bookCopiesUser.userID = userID and bookCopiesUser.ISBN = ISBN;
if(cid == NULL) then
    -- User doesn't have book on loan
    insert into holdRequest values(ISBN, userID, current_timestamp);
    set status = 1;
else 
    -- temp1 is list of other users who put a hold on same book
    create table temp1
    select holdRequest.userID from holdRequest
    where holdRequest.ISBN = ISBN;
    select count(temp1.userID) into size1 from temp1;
    -- temp2 is list of users in temp1 who are trying for loan and hold
    create table temp2
    select bookCopiesUser.userID from bookCopiesUser
    where bookCopiesUser.ISBN = ISBN and 
    bookCopiesUser.action = 'loan' and
    bookCopiesUser.userID in
    (select temp1.userID from temp1);
    select count(temp2.userID) into size2 from temp2;
    if(size1 == size2) then
        -- All users are trying for loan and hold
        -- Fetch user type, unpaid fines and total books put under hold by the user
        select user.unpaidFines into unpaidFine from user where user.userID = userID;
        select account.accountType into userType from account where account.accountID = userID;
        select count(bookCopiesUser.ISBN) into holdLimit1 from bookCopiesUser
        where bookCopiesUser.userID = userID;
        select count(holdRequest.ISBN) into holdLimit2 from holdRequest
        where holdRequest.userID = userID;
        if(userType = 'student' and (holdLimit1 + holdLimit2) >2 ) then
            -- hold limit (approved and active) is 3 for students
            set status = 3;
        elseif(userType = 'professor' and (holdLimit1 + holdLimit2) > 4) then
            -- hold limit (approved and active) is 5 for professors
            set status = 3;
        elseif(unpaidFine > 1000) then
            -- books can't be issued or hold if unpaid fine > 1000
            set status = 4;
        else
            -- All conditions satisfied to request hold
            insert into holdRequest values(ISBN, userID, current_timestamp());
            set status = 1;
        end if;
    else
        -- Atleast one user doesn't have the book and has put hold
        set status = 2;
    end if;
    drop table temp2;
    drop table temp1;
end if;
end //
delimiter ;

-- call procedure
call requestHold(100, '123', @status);
select @status;
-- status = 1 : Hold request placed
-- status = 2 : Hold already placed by someone else
-- status = 3 : Hold limit crossed
-- status = 4 : Unpaid Fines limit crossed

-- drop procedure requestHold;