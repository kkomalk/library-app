-- Sign up an User
-- procedure definition
delimiter //
create procedure signUpUser(
    in email varchar(70),
    in password varchar(200),
    in name varchar(50),
    in address varchar(500),
    in type varchar(20)
)
begin
insert into account values(password, type, email);
insert into user values(@userID, name, email, address, 0);
end //
delimiter ;

-- call procedure
call signUpUser('abc@gmail.com', 'xyz', 'ram', 'alz', 'student');

-- drop procedure signUpUser;