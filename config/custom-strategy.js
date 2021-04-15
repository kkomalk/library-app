const passport = require('passport');
const passportCustom = require('passport-custom');
const CustomStrategy = passportCustom.Strategy;
const LocalStrategy = require('passport-local').Strategy;
const flash = require('connect-flash');
passport.serializeUser((user, done) => {
    done(null, user.accountID);
});

passport.deserializeUser((id, done) => {
    let sql = 'select * from account where accountID = '+id;
    connection.query(sql,(err,result)=>{
        done(null,result[0]);
    })
});


passport.use('local',new LocalStrategy({usernameField : 'email',passwordField: 'password',passReqToCallback:true},
    (req,username,password,done)=>{
        // console.log(req);
        console.log(username,password);
        let sql = `select * from account where email= ? and password=?`;
        connection.query(sql,[username,password],(err,result)=>{
            if(result.length){
                done(null,result[0]);
            }else{
                console.log('boom');
                done(null,false,req.flash("error", 'Wrong email or password'));
            }
        })
    }
))
