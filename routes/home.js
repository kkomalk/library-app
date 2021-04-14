const router = require('express').Router();
const path = '../views/home/';
const mysql = require('mysql');

router.get('/',(req,res)=>{
    connection.query('select * from account;',(err,result) => {
        if(err) throw err;
        // res.send(JSON.stringify(result));
        console.log(result);
        res.render(path+'home.ejs', {data : JSON.stringify(result)});
    })
})

router.post('/displayinfo',(req,res)=>{
    connection.query('select * from person;',(err,result) => {
        if(err) throw err;
        console.log(result);
        res.send(result);
    })
})

module.exports = router;