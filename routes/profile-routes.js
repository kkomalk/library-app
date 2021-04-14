const router = require('express').Router();

const authCheck = (req, res, next) => {
    if (!req.user) {
        res.redirect('/auth/login');
    } else {
        next();
    }
}

router.get('/', authCheck, (req, res) => {
    // res.render('profile', { user: req.user });
    res.send('you are in profile');
});

module.exports = router;