-- Send friend request
-- procedure definition
delimiter //
create procedure sendFriendRequest(
    in requesterID int,
    in requestedID int
)
begin
insert into friendRequest values(requesterID, requestedID);
end //
delimiter ;

-- call procedure
call sendFriendRequest(100, 120);

-- drop procedure sendFriendRequest;