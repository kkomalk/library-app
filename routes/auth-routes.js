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

router.post('/login',passport.authenticate('local',{failureRedirect: '/auth/login',failureFlash:true,passReqToCallback:true}),(req,res)=>{
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
    let error=req.query.error;
    console.log(error);
    res.render(path+'signup',{name,email,path : href,error : req.flash('error')});
})

router.post('/signup',async (req,res)=>{
    let name = req.body.name;
    let email=req.body.email;
    let address=req.body.address;
    let type=req.body.type;
    let pass=req.body.password;
    let repass=req.body.repassword;
    if(pass!=repass){
        console.log(1);
        req.flash('error','passwords do not match');
        res.redirect('/auth/signup/?error=passwords+do+not+match');
    }else{
        console.log(2);
        let flag = await cquery(`select * from account where email = '${email}';`,req,res);
        if(flag==1){
            req.flash('error','email is already registered');
            res.redirect('/auth/signup');
        }else{
            console.log(3);
            res.send('you are signed up now!!!');
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