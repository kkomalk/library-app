-- All details of book and associations with user
delimiter //
create procedure detailsOfBook(
	in userID int,
    in ISBN varchar(15)
)
begin
declare title varchar(100);
declare yearOfPublication int;
declare totalCopies int;
declare noOfCopiesOnShelf int;
declare authors varchar(200);
declare category varchar(20);
declare image varchar(1000);
declare fav int;
declare rating int;
declare holdStatus int;
declare avgRating float;
declare x varchar(3);
declare y varchar(20);
select book.title into title from book where book.ISBN = ISBN;
select book.yearOfPublication into yearOfPublication from book where book.ISBN = ISBN;
select book.totalCopies into totalCopies from book where book.ISBN = ISBN;
select book.noOfCopiesOnShelf into noOfCopiesOnShelf from book where book.ISBN = ISBN;
select book.authors into authors from book where book.ISBN = ISBN;
select book.category into category from book where book.ISBN = ISBN;
select book.image into image from book where book.ISBN = ISBN;
select readingList.favourite into x from readingList where readingList.userID = userID and readingList.ISBN = ISBN;
if(x = 'YES') then
	set fav = 1;
else
	set fav = 0;
end if;
select rating.rating into rating from rating where rating.userID = userID and rating.ISBN = ISBN;
select bookcopiesuser.action into y from bookcopiesuser where bookcopiesuser.userID = userID and bookcopiesuser.ISBN = ISBN;
if(y = NULL or y = 'loan') then
	set holdStatus = 1;
else 
	set holdStatus = 0;
end if;
select avg(rating.rating) from rating where rating.ISBN = ISBN;
create table temp4(
title varchar(100),
yearOfPublication int,
totalCopies int,
noOfCopiesOnShelf int,
authors varchar(200),
category varchar(20),
image varchar(1000),
fav int,
rating int,
holdStatus int,
avgRating float
);
insert into temp4 values(title, yearOfPublication, totalCopies, noOfCopiesOnShelf, authors, category, image, fav, rating, holdStatus, avgRating);
select * from temp4;
drop table temp4;
end //
delimiter ;

-- call procedure
call detailsOfBook(4, '123');

-- drop procedure detailsOfBook;