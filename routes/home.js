const router = require('express').Router();
const path = '../views/home/';
const mysql = require('mysql');
const href = 'http://localhost:5000/';

router.get('/',(req,res)=>{
    res.render(path+'home_page.ejs',{path : href});
})

router.get('/books',(req,res)=>{
    res.render(path+'books.ejs',{path : href});
})

router.post('/displayinfo',(req,res)=>{
    connection.query('select * from person;',(err,result) => {
        if(err) throw err;
        console.log(result);
        res.send(result);
    })
})

module.exports = router;