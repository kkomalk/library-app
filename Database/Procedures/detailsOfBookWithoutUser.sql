-- Details Of Book Without User
delimiter //
create procedure detailsOfBookWithoutUser(
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
declare avgRating1 float;
select book.title into title1 from book where book.ISBN = ISBN;
select book.yearOfPublication into yearOfPublication1 from book where book.ISBN = ISBN;
select book.totalCopies into totalCopies1 from book where book.ISBN = ISBN;
select book.noOfCopiesOnShelf into noOfCopiesOnShelf1 from book where book.ISBN = ISBN;
select book.authors into authors1 from book where book.ISBN = ISBN;
select book.category into category1 from book where book.ISBN = ISBN;
select book.image into image1 from book where book.ISBN = ISBN;
select avg(rating.rating) into avgRating1 from rating where rating.ISBN = ISBN;
create table temp4(
title varchar(100),
yearOfPublication int,
totalCopies int,
noOfCopiesOnShelf int,
authors varchar(200),
category varchar(20),
image varchar(1000),
avgRating float
);
insert into temp4 values(title1, yearOfPublication1, totalCopies1, noOfCopiesOnShelf1, authors1, category1, image1, avgRating1);
select * from temp4;
drop table temp4;
end //
delimiter ;

-- call procedure
call detailsOfBookWithoutUser('123');

-- drop procedure detailsOfBookWithoutUser;