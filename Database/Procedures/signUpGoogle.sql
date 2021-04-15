-- Sign Up using Google
-- procedure definition
delimiter //
create procedure signUpGoogle(
    in email varchar(70),
    in name varchar(50),
    in type varchar(20),
    in address varchar(500),
    out did int
)
begin
declare exit handler for 1062
begin
set did = 1;
end;
declare userID int;
insert into account values(NULL, type, email);
select account.accountID into userID from account where account.email = email;
insert into user values(userID, name, email, address, 0);
end //
delimiter ;

-- call procedure
call signUpGoogle('abc@gmail.com', 'xyz', 'professor', 'alz', @did);
select @did;

-- drop procedure signUpGoogle;