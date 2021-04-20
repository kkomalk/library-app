const { createConnection } = require('mysql');

const router = require('express').Router();
const path = '../views/librarian/';
const href = 'http://localhost:5000/';

const cquery = async (sql) => {
    return new Promise((resolve, reject) => {
        connection.query(sql, (err, result) => {
            if (err) throw err;
            resolve(result);
        })
    }
    )
}

router.get('/home', async (req, res) => {
    let temp = await cquery(`select * from librarian where librarian.librarianID = ${req.user.accountID};`);
    console.log(temp);
    let message = req.query.msg;
    let form = req.query.form;
    res.render(path + 'librarian_home.ejs', { path: href, name: temp[0].name, address: temp[0].address, id: temp[0].librarianID, message: message, form: form});
})

router.post('/addbook', async (req, res) => {
    let obj = req.body;
    await cquery(`call addBook('${obj.isbn}', '${obj.title}', ${obj.year}, ${obj.copies}, '${obj.authors}', '${obj.category}', '${obj.image}', ${obj.shelfid}, @did, @inv);`);
    let did = await cquery(`select @did;`);
    let inv = await cquery(`select @inv;`);
    console.log(did);
    console.log(inv);
    if(did[0]['@did'] == 1){
        let errorString = 'Duplicate ISBN found. Unable to add book to database';
        res.redirect(`/librarian/home?msg=${errorString}&form=add`);
    }
    else if(inv[0]['@inv'] == 1){
        let errorString = 'Shelf Capacity is insufficient...Please select a different shelf';
        res.redirect(`/librarian/home?msg=${errorString}&form=add`);
    }
    else res.redirect(`/librarian/home?msg=Book+Added+Succesfully&form=add`);
})

router.post('/deletebook', async (req, res) => {
    let obj = req.body;
    await cquery(`call deleteBook('${obj.isbn}', @inv);`);
    let inv = await cquery(`select @inv;`);
    if(inv[0]['@inv'] == 0){
        let errorString = 'Active Hold Requests Exist';
        res.redirect(`/librarian/home?msg=${errorString}&form=delete`);
    }
    else if(inv[0]['@inv'] == 1){
        let errorString = 'Unable to Delete. Some approved holds exist';
        res.redirect(`/librarian/home?msg=${errorString}&form=delete`);
    }
    else if(inv[0]['@inv'] == 2){
        let errorString = 'Unable to Delete. Some copies on loan.';
        res.redirect(`/librarian/home?msg=${errorString}&form=delete`);
    }
    else{
        let errorString = 'Book Deleted Succesfully';
        res.redirect(`/librarian/home?msg=${errorString}&form=delete`);
    }
})

router.post('/updatebook', async (req, res) => {
    let obj = req.body;
    await cquery(`call updateBook('${obj.isbn}', '${obj.title}', ${obj.year}, '${obj.author}', '${obj.category}', '${obj.image}', ${obj.copies}, ${obj.shelf}, @inv);`);
    let inv = await cquery(`select @inv;`);
    if(inv[0]['@inv'] == 1){
        let errorString = 'Unable to Update. Please check number of copies';
        res.redirect(`/librarian/home?msg=${errorString}&form=update`);
    }
    else if(inv[0]['@inv'] == 2){
        let errorString = 'Unable to Update. Shelf Capacity is less.';
        res.redirect(`/librarian/home?msg=${errorString}&form=update`);
    }
    else{
        let errorString = 'Book Updated Succesfully';
        res.redirect(`/librarian/home?msg=${errorString}&form=update`);
    }
})

router.post('/issuebook', async (req, res) => {
    let obj = req.body;
    let userID = await cquery(`select user.userID from user where user.email = '${obj.email}';`);
    await cquery(`call issueBook(${userID[0]['userID']}, '${obj.isbn}', ${obj.copyid}, @success, @dueDate);`);
    let success = await cquery(`select @success;`);
    if(success[0]['@success'] == 1){
        let dueDate = await cquery(`select @dueDate;`);
        let message = `Book issued succesfully and due date is ${dueDate[0]['@dueDate']}`;
        res.redirect(`/librarian/home?msg=${message}&form=issue`);
    }
    else{
        let errorString = 'Book can not be issued due to borrow limit or fine limit';
        res.redirect(`/librarian/home?msg=${errorString}&form=issue`);
    }
})

router.post('/withdrawbook', async (req, res) => {
    let obj = req.body;
    let userID = await cquery(`select user.userID from user where user.email = '${obj.email}';`);
    await cquery(`call returnBook(${userID[0]['userID']}, '${obj.isbn}', ${obj.copyid});`);
    let message = `Book Returned to shelf succesfully`;
    res.redirect(`/librarian/home?msg=${message}&form=withdraw`);
})

router.post('/fine', async (req, res) => {
    let obj = req.body;
    await cquery(`update user set user.unpaidFines = 0 where user.email = '${obj.email}';`);
    let message = `Dues cleared`;
    res.redirect(`/librarian/home?msg=${message}&form=fine`);
})

module.exports = router;