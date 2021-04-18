-- Unused Shelf capacity
delimiter //
create procedure shelfCapacity(
	in shelfID int
)
begin
declare presentShelf int;
declare totalCapacity int;
select shelf.capacity into totalCapacity from shelf where shelf.shelfID = shelfID;
select count(bookCopies.ISBN) into presentShelf from bookCopies where bookCopies.shelfID = shelfID;
select (totalCapacity - presentShelf); 
end //
delimiter ;

-- call procedure
call shelfCapacity(12);

-- drop procedure shelfCapacity;