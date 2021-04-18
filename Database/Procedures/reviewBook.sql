-- Review a book
-- procedure definition
delimiter //
create procedure reviewBook(
    in userID int,
    in ISBN varchar(15),
    in reviewText varchar(500)
)
begin
declare review varchar(500);
set review = '';
select review.reviewText into review from review where review.userID = userID and review.ISBN = ISBN;
if(review = '') then 
insert into review(reviewText, userID, ISBN) values(reviewText, userID, ISBN);
else
update review set review.reviewText = reviewText where review.userID = userID and review.ISBN = ISBN;
end if;
end //
delimiter ;

-- call procedure
call reviewBook(4, '123', 'lorem10');

-- drop procedure reviewBook;