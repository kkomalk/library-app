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
    res.render(path + 'librarian_home.ejs', { path: href, name: temp[0].name, address: temp[0].address, id: temp[0].librarianID, message: message });
})

router.post('/addbook', async (req, res) => {
    let obj = req.body;
    await cquery(`call addBook('${obj.isbn}', '${obj.title}', ${obj.year}, ${obj.copies}, '${obj.authors}', '${obj.category}', '${obj.image}', ${obj.shelfid}, @did, @inv);`);
    let did = await cquery(`select @did;`);
    let inv = await cquery(`select @inv;`);
    console.log(did);
    console.log(inv);
    if(did[0]['@did'] == 1){
        let errorString = 'Duplicate ISBN found...Unable to add book to database';
        res.redirect(`/librarian/home?msg=${errorString}`);
    }
    else if(inv[0]['@inv'] == 1){
        let errorString = 'Shelf Capacity is insufficient...Please select a different shelf';
        res.redirect(`/librarian/home?msg=${errorString}`);
    }
    else res.redirect(`/librarian/home?msg=Book+Added+Succesfully`);
})

router.post('/deletebook', async (req, res) => {
    console.log(req.body);
    res.send({});
})

router.post('/updatebook', async (req, res) => {
    console.log(req.body);
    res.send({});
})

module.exports = router;