-- Unfriend
-- procedure definition
delimiter //
create procedure unfriend(
    in userID int,
    in friendID int
)
begin
delete from friendUser where friendUser.userID = userID and friendUser.friendID = friendID;
delete from friendUser where friendUser.userID = friendID and friendUser.friendID = userID;
end //
delimiter ;

-- call procedure
call unfriend(4, 5);

-- drop procedure unfriend;