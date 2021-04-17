-- All reviews of book
delimiter //
create procedure reviewsOfBook(
	in ISBN varchar(15)
)
begin
select user.userID, user.name, review.reviewText
from user inner join review
on user.userID = review.userID
where review.ISBN = ISBN;
end //
delimiter ;

-- call procedure
call reviewsOfBook('123');

-- drop procedure reviewsOfBook;