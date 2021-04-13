const router = require('express').Router();
const path = '../views/home/';
const mysql = require('mysql');

router.route('/').get((req,res)=>{
    connection.query('select * from person;',(err,result) => {
        if(err) throw err;
        console.log(result);
    })
    res.render(path+'home.ejs')
})

module.exports = router;