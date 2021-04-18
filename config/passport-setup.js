const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20');
const keys = require('./keys');

passport.serializeUser((user, done) => {
    done(null, user.accountID);
});

passport.deserializeUser((id, done) => {
    if(id==-1){
        done(null,{accountID:-1});
    }else{

        let sql = 'select * from account where accountID = '+id;
        connection.query(sql,(err,result)=>{
            if(result.length){
                done(null,result[0]);
            }else{
                done(null,null);
            }
        })
    }
});


passport.use(
    new GoogleStrategy({
        clientID: keys.clientID,
        clientSecret: keys.clientSecret,
        callbackURL: '/auth/google/redirect',
        passReqToCallback: true
    }, (req,accessToken, refreshToken, profile,email, done) => {
        let sql = 'select * from account where email = ?';
        connection.query(sql,email.emails[0].value,(err,result)=>{
            if(err) throw err;
            console.log(email);
            req.email=email.emails[0].value;
            req.name=email.name.givenName;
            req.fname=email.name.familyName;
            if(result.length){
                done(null,result[0]);
                
            }else{
                req.added=false;
                // console.log(req.added);
                done(null,{accountID : -1});
            }

        })
    })
)