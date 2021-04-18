const { createConnection } = require('mysql');

const router = require('express').Router();
const path = '../views/librarian/';
const href = 'http://localhost:5000/';

const cquery = async  (sql)=>{
    return new Promise((resolve,reject)=>{
        connection.query(sql,(err,result)=>{
            if(err) throw err;
            resolve(result);
        })
    }
    )
}

router.get('/home',async (req,res)=>{
    let temp = await cquery(`select * from librarian where librarian.librarianID = ${req.user.accountID};`);
    console.log(temp);
    res.render(path+'librarian_home.ejs',{path : href, name : temp[0].name, address : temp[0].address, id : temp[0].librarianID});
})

router.post('/addbook', async (req, res) => {
    console.log(req.body);
    res.send({});
})

module.exports=router;