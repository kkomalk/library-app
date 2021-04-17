-- Return a book to library by user
-- procedure definition
delimiter //
create procedure returnBook(
    in userID int,
    in ISBN varchar(15),
    in copyID int
)
begin
delete from bookCopiesUser where bookCopiesUser.userID = userID and 
bookCopiesUser.ISBN = ISBN and bookCopiesUser.copyID = copyID;
update bookCopies set bookCopies.bookStatus = 'shelf', bookCopies.dueDate = NULL
where bookCopies.ISBN = ISBN and bookCopies.copyID = copyID;
update book set book.noOfCopiesOnShelf = book.noOfCopiesOnShelf + 1
where book.ISBN = ISBN;
end //
delimiter ;

-- call procedure
call returnBook(100, '123', 2);

-- drop procedure returnBook;