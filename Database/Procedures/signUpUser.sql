-- Sign up an User
-- procedure definition
delimiter //
create procedure signUpUser(
    in email varchar(70),
    in password varchar(200),
    in name varchar(50),
    in address varchar(500),
    in type varchar(20),
    out did int
)
begin
declare userID int;
declare exit handler for 1062
begin
set did = 1;
end;
insert into account(password, accountType, email) values(password, type, email);
select account.accountID into userID from account where account.email = email;
insert into user values(userID, name, email, address, 0);
end //
delimiter ;

-- call procedure
call signUpUser('abc@gmail.com', 'xyz', 'ram', 'alz', 'student', @did);
select @did;

-- drop procedure signUpUser;