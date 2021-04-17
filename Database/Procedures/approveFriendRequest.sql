-- Accept friend request
-- Referential Integrity Failure to be handled by Front End
delimiter //
create procedure approveFriendRequest(
	in userID int,
	in requesterID int
)
begin
insert into friendUser values(userID, requesterID);
insert into friendUser values(requesterID, userID);
delete from friendRequest where friendRequest.requestedID = userID and friendRequest.requesterID = requesterID;
end //
delimiter ;

-- call procedure
call approveFriendRequest(5, 4);

-- drop procedure approveFriendRequest;
