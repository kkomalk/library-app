-- Add a book (by the librarian)
-- procedure definition
delimiter //
create procedure addBook(
    in ISBN varchar(15),
    in title varchar(100),
    in yearOfPublication int,
    in noOfCopies int,
    in authors varchar(200),
    in shelfID int,
    out did int,
    out inv int
)
b: begin
declare x int;
declare shelfBooks int;
declare shelfCapacity int;
declare exit handler for 1062
begin
set did=1;
end;
select count(bookCopies.bookStatus) into shelfBooks from bookCopies 
where bookCopies.bookStatus = 'shelf' and bookCopies.shelfID = shelfID;
select shelf.capacity into shelfCapacity from shelf where shelf.shelfID = shelfID;
if((shelfCapacity - shelfBooks) < noOfCopies) then
    set inv=1;
    leave b;
end if;
insert into book values(ISBN, title, yearOfPublication, noOfCopies, noOfCopies, authors);
set x = 1;
a:loop
    if(x >= noOfCopies) then
        leave a;
    end if;
    insert into bookCopies values(ISBN, x, 'shelf', NULL, shelfID);
    set x = x + 1;
end loop;
end //
delimiter ;

-- call procedure
call addBook('123', 'ALgorithms', 2010, 5, 'Cormen', 12, @did, @inv);
select @did;
select @inv;

-- drop procedure addBook;