-- Generate a new User ID while signing up
-- procedure definition
delimiter //
create procedure generateUserID(
    out userID int
)
begin
    declare temp int;
    select max(accountID) into temp from account;
    if(temp is null) set temp = 0;
    set userID = temp+1;
end //
delimiter ;

-- call procedure
call generateUserID(@userid);
select @userid;

-- drop procedure generateUserID;