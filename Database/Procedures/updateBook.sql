-- update details of a book
-- procedure definition
delimiter //
create procedure updateBook(
    in ISBN varchar(15),
    in title varchar(100),
    in yearOfPublication int,
    in authors varchar(200),
    in noOfCopies int,
    in shelfID int,
    out inv int
)
b: begin
declare presentNo int;
declare presentShelf int;
declare updateShelf int;
declare shelfCapacity int;
declare x int;
declare y int;
declare z varchar(20);
declare maxCopyID int;
select book.totalCopies into presentNo from book where book.ISBN = ISBN;
if(noOfCopies >= presentNo) then
    set updateShelf = noOfCopies - presentNo;
    select book.noOfCopiesOnShelf into presentShelf from book
    where book.ISBN = ISBN;
    select shelf.capacity into shelfCapacity from shelf where shelf.shelfID = shelfID;
    if(updateShelf > shelfCapacity - presentShelf) then
        set inv = 2;
        leave b;
    end if; 
    update book set book.title = title, book.yearOfPublication = yearOfPublication,
    book.authors = authors, book.totalCopies = noOfCopies,
    book.noOfCopiesOnShelf = book.noOfCopiesOnShelf + updateShelf
    where book.ISBN = ISBN;
    set x = presentNo + 1;
    a:loop
        if(x > updateShelf + presentNo) then
            leave a;
        end if;
        insert into bookCopies values(ISBN, x, 'shelf', NULL, shelfID)
        set x = x + 1;
    end loop;
else
    select book.noOfCopiesOnShelf into presentShelf from book 
    where book.ISBN = ISBN;
    if(presentShelf >= presentNo - noOfCopies) then
        update book set book.title = title, book.yearOfPublication = yearOfPublication,
        book.authors = authors, book.totalCopies = noOfCopies,
        book.noOfCopiesOnShelf = book.noOfCopiesOnShelf - presentNo + noOfCopies
        where book.ISBN = ISBN;
        select max(bookCopies.copyID) into maxCopyID from bookCopies
        where bookCopies.ISBN = ISBN and bookCopies.bookStatus = 'shelf';
        set y = 1;
        c: loop
            if(y > presentNo - noOfCopies) then
                leave c;
            end if;
            select bookCopies.bookStatus into z from bookCopies where bookCopies.ISBN = ISBN and bookCopies.copyID = maxCopyID;
            if(z = 'shelf') then 
                delete from bookCopies where bookCopies.ISBN = ISBN and bookCopies.copyID = maxCopyID and bookCopies.bookStatus = 'shelf';
                set y = y + 1;
            end if;    
            set maxCopyID = maxCopyID - 1;
        end loop;
    else
        set inv = 1;
    end if;    
end if;
end //
delimiter ;

-- call procedure
call updateBook('123', 'Algorithms', 2012, 'Cormen', 20, @inv);
select @inv;   -- If noOfCOpies is faulty(1) or shelf capacity is less(2)

-- drop procedure updateBook;