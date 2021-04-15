-- Authenticate username and password of user and return account type
-- procedure definition
delimiter //
create procedure authenticate(
    in email varchar(70),
    in password varchar(200),
    out success int,
    out type varchar(20)
)
begin
declare pwd varchar(200);
select account.password into pwd 
from account
where account.email = email;
if(pwd = NULL) then
    set success =0;
    set type = 'dne';
elseif(password != pwd) then
    set success = 0;
    set type = 'invalid';
else
    set success = 1;
    select account.accountType into type where account.email = email;
end if;
end //
delimiter ;

-- call procedure
call authenticate(100, 'abc', @success, @type);
select @success;
select @type;

-- drop procedure authenticate;