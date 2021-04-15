-- Unfriend
-- procedure definition
delimiter //
create procedure unfriend(
    in userID int,
    in friendID int
)
begin
delete from friendUser where friendUser.userID = userID and friendUser.friendID = friendID;
end //
delimiter ;

-- call procedure
call unfriend(100, 120);

-- drop procedure unfriend;