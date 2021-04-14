-- Sign Up using Google
-- procedure definition
delimiter //
create procedure signUpGoogle(
    in email varchar(70),
    in name varchar(50),
    in type varchar(20),
    in address varchar(500)
)
begin
call generateUserID(@userID);
insert into account values(@userID, '', type);
insert into user values(@userID, name, email, address, 0);
end //
delimiter ;

-- call procedure
call signUpGoogle('abc@gmail.com', 'xyz', 'professor', 'alz');

-- drop procedure signUpGoogle;