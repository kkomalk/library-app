const router = require('express').Router();

router.route('/').get((req,res)=>{
    res.send("Well Hello There!!");
})

module.exports = router;