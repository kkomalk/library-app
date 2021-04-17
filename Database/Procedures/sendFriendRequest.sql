-- Send friend request
-- procedure definition
-- Referential Integrity Failure to be handled by Front-End
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
call sendFriendRequest(4, 5);

-- drop procedure sendFriendRequest;