const router = require('express').Router();
const path = '../views/user/';
const href = 'http://localhost:5000/';


const cquery = async  (sql,req,res)=>{
    return new Promise((resolve,reject)=>{
        connection.query(sql,(err,result)=>{
            if(err) console.log(err);
            else resolve(result);
        })
    }
    )
}

let books = [];

router.get('/books',async(req,res)=>{
    res.render(path+'books.ejs',{path : href});
})

router.get('/home',async (req,res)=>{
    let userid=req.user.accountID;
    let temp = await cquery(`select name,address from user where userID=${userid};`);
    let name = temp[0].name;
    let address = temp[0].address;
    console.log(temp);
    res.render(path+'user_home.ejs',{path : href,name,address,userid});
});

router.get('/temp',(req,res)=>{
    res.render(path+'temp',{path : href});
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
            let temp1 = await cquery(`call detailsOfBook(${req.user.accountID},${books[i].ISBN})`);
            let str="";
            if(c== "Search by Name"){
                str = ""+books[i].title;
            }else{
                str = ""+books[i].authors;
            }
            console.log(temp1[1]);
            if(str.indexOf(sub) > -1){
                temp1[1][0].avgRat = temp1[0][0]["avg(rating.rating)"];
                temp1[1][0].ISBN = books[i].ISBN;
                let temp2 = await cquery(`call reviewsOfBook(${books[i].ISBN});`);
                temp1[1][0].reviews = temp2[0];
                // console.log(temp1[1]);
                result.push(temp1[1][0]);
            }
        }
        res.send(result);
    }

})

router.post('/markfav', async(req,res)=>{
    let isbn = req.body.isbn;
    let read = req.body.read;
    if(read == 'yes'){
        read=1;
    }else{
        read=0;
    }
    await cquery(`call markAsFavourite(${req.user.accountID},${isbn},${read});`);
    res.send({
        message: 'successs'
    })
})

router.post('/unmarkfav',async(req,res)=>{
    let isbn=req.body.isbn;
    await cquery(`call removeFromFavourite(${req.user.accountID},${isbn});`);
    res.send({
        message: 'success'
    })
})

router.post('/rate',async(req,res)=>{
    let isbn =req.body.isbn;
    let rating = req.body.isbn;
    
})

module.exports = router;