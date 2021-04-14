const router = require('express').Router();
const passport = require('passport');
const path = '../views/common/';

router.get('/login', (req, res) => {
    console.log(req.user, req.id , req.userid);
    if(req.user){
        res.send('you are already logged in');
    }else{
    res.render(path+'login', { user: req.user });
    }
});


router.get('/logout', (req, res) => {
    req.logout();
    res.redirect('/');
})

router.get('/google', passport.authenticate('google', {
    scope: ['profile','email']
}))


router.get('/google/redirect', passport.authenticate('google', { failureRedirect: '/auth/login' }), (req, res) => {
        res.send(req.user);
    
})

module.exports = router;