const router = require('express').Router();
const passport = require('passport');
const path = '../views/common/';
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

router.get('/login', (req, res) => {
    if (req.user) {
        res.send('you are already logged in');
    } else {
        // console.log(req.flash('error')[0],'here');
        let error = req.flash('error')[0];
        res.render(path + 'login',{path: href,error});
    }
});

router.post('/login',passport.authenticate('local',{failureRedirect: '/auth/login',failureFlash:true,passReqToCallback:true}),async (req,res)=>{
    let id = req.user.accountID;
    let temp = await cquery(`select accountType from account where accountID = ${id};`);
    console.log(temp);
    res.redirect('/profile');
})

router.get('/logout', (req, res) => {
    req.logout();
    res.redirect('/');
})

router.get('/google', passport.authenticate('google', {
    scope: ['profile', 'email']
}))

router.get('/signup',(req,res)=>{
    let name=req.query.name;
    let email = req.query.email;
    let error=req.flash('error');
    res.render(path+'signup',{name,email,path : href,error});
})

router.post('/signup',async (req,res)=>{
    let name = req.body.name;
    let email=req.body.email;
    let address=req.body.address;
    let type=req.body.type;
    let pass=req.body.password;
    let repass=req.body.repassword;
    if(pass!=repass){
        req.flash('error','passwords do not match');
        res.redirect('/auth/signup/');
    }else{ 
        let flag = await cquery(`select * from account where email = '${email}';`,req,res);
        if(flag.length){
            req.flash('error','email is already registered');
            res.redirect('/auth/signup');
        }else{
            let temp = await cquery(`call signUpUser('${email}','${pass}','${name}','${address}','${type}');`);
            req.flash('error','You are signed up now. Please login.');
            res.redirect('/auth/login');
        }
    }
})

router.get('/google/redirect', passport.authenticate('google'), (req, res) => {
    // console.log(err,'here');
    console.log(req.user);
    console.log(req.added);
    if(req.added==false){
        req.logout();
        res.redirect('/auth/signup?'+'name='+req.name+"+"+req.fname+'&email='+req.email);
        // req.logout();
    }else{
        res.redirect('/profile');
    }
})

module.exports = router;