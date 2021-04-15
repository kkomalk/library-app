const router = require('express').Router();
const passport = require('passport');
const path = '../views/common/';
const href = 'http://localhost:5000/';


router.get('/login', (req, res) => {
    console.log(req.flash('error'),'here');
    if (req.user) {
        res.send('you are already logged in');
    } else {
        res.render(path + 'register',{path: href});
    }
});

// router.post('/login',(req,res)=>{
//     console.log(req.body.email);
// })

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
    res.render(path+'signup',{path : href});
})

router.get('/google/redirect', passport.authenticate('google', { failureRedirect: '/auth/login' }), (req, res) => {
    // console.log(err,'here');

    res.redirect('/profile');
})


module.exports = router;