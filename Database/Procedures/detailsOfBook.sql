-- All details of book and associations with user
delimiter //
create procedure detailsOfBook(
	in userID int,
    in ISBN varchar(15)
)
begin
declare title1 varchar(100);
declare yearOfPublication1 int;
declare totalCopies1 int;
declare noOfCopiesOnShelf1 int;
declare authors1 varchar(200);
declare category1 varchar(20);
declare image1 varchar(1000);
declare fav1 int;
declare userRating1 int;
declare holdStatus1 int;
declare avgRating1 float;
declare x1 varchar(3);
declare y1 varchar(20);
set y1 = 'NUll';
set x1 = 'YE';
select book.title into title1 from book where book.ISBN = ISBN;
select book.yearOfPublication into yearOfPublication1 from book where book.ISBN = ISBN;
select book.totalCopies into totalCopies1 from book where book.ISBN = ISBN;
select book.noOfCopiesOnShelf into noOfCopiesOnShelf1 from book where book.ISBN = ISBN;
select book.authors into authors1 from book where book.ISBN = ISBN;
select book.category into category1 from book where book.ISBN = ISBN;
select book.image into image1 from book where book.ISBN = ISBN;
select readingList.favourite into x1 from readingList where readingList.userID = userID and readingList.ISBN = ISBN;
if(x1 = 'YES') then
	set fav1 = 1;
else
	set fav1 = 0;
end if;
select rating.rating into userRating1 from rating where rating.userID = userID and rating.ISBN = ISBN;
select bookCopiesUser.action into y1 from bookCopiesUser where bookCopiesUser.userID = userID and bookCopiesUser.ISBN = ISBN;
if(y1 = 'hold' or y1 = 'loan&hold') then
	set holdStatus1 = 0;
else 
	set holdStatus1 = 1;
end if;
select avg(rating.rating) into avgRating1 from rating where rating.ISBN = ISBN;
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
avgRating float,
primary key(title)
);
insert into temp4 values(title1, yearOfPublication1, totalCopies1, noOfCopiesOnShelf1, authors1, category1, image1, fav1, userRating1, holdStatus1, avgRating1);
select * from temp4;
drop table temp4;
end //
delimiter ;

-- call procedure
call detailsOfBook(24, '123');

-- drop procedure detailsOfBook;