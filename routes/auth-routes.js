const router = require('express').Router();
const passport = require('passport');
const path = '../views/common/';
const href = 'http://localhost:5000/';


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
    res.render(path+'signup',{name,email,path : href});
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