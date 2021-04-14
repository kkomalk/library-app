const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20');
const keys = require('./keys');

passport.serializeUser((user, done) => {
    done(null, user.userid);
});

passport.deserializeUser((id, done) => {
    let sql = 'select * from account where userid = '+id;
    connection.query(sql,(err,result)=>{
        // console.log(id,result);
        done(null,result[0]);
    })
});


passport.use(
    new GoogleStrategy({
        clientID: keys.clientID,
        clientSecret: keys.clientSecret,
        callbackURL: '/auth/google/redirect'
    }, (accessToken, refreshToken, profile,email, done) => {
        // done(null,profile);
        let sql = 'select * from account where email = ?';
        connection.query(sql,email.emails[0].value,(err,result)=>{
            if(err) throw err;
            if(result.length){
                done(null,result[0]);
            }else{
                done(null,false,{error : 'Invalid user'});
            }
        })
    })
)