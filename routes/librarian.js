const router = require('express').Router();
const path = '../views/librarian/';
const href = 'http://localhost:5000/';
router.get('/home',(req,res)=>{
    res.render(path+'librarian_home.ejs',{path : href});
})

module.exports=router;