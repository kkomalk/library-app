const router = require('express').Router();
const path = '../views/home/';
const mysql = require('mysql');
const href = 'http://localhost:5000/';

const cquery = async  (sql,req,res)=>{
    return new Promise((resolve,reject)=>{
        connection.query(sql,(err,result)=>{
            if(err) throw err;
            resolve(result);
        })
    }
    )
}

let books = [];


router.get('/',(req,res)=>{
    res.render(path+'home_page.ejs',{path : href});
})

router.get('/books',(req,res)=>{
    res.render(path+'books_without_login.ejs',{path : href});
})

router.post('/displayinfo',(req,res)=>{
    connection.query('select * from person;',(err,result) => {
        if(err) throw err;
        console.log(result);
        res.send(result);
    })
})

router.post('/getbooksdata',async (req,res)=>{
    let c = req.body.criteria;
    let sub=req.body.sub;
    if(books.length == 0){
        console.log('called');
        books = await cquery('select * from book;');
    }

    if(sub.length == 0){
        res.send({});
    }else{
        let result = [];
        for(let i=0;i<books.length;i++){
            let str="";
            if(c== "Search by Name"){
                str = ""+books[i].title;
            }else{
                str = ""+books[i].authors;
            }
            books[i].rating=4;
            console.log(books);
            if(str.indexOf(sub) > -1){
                result.push(books[i]);
            }
        }
        res.send(result);
    }

})

module.exports = router;