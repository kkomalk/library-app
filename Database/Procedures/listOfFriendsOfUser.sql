-- Fetch List of friends of a user
-- procedure definition
delimiter //
create procedure listOfFriendsOfUser(
    in userID int
)
begin
select friendUser.friendID from friendUser where friendUser.userID = userID;
end //
delimiter ;

-- call procedure
call listOfFriendsOfUser(100);

-- drop procedure listOfFriendsOfUser;