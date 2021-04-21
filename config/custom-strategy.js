const passport = require('passport');
const passportCustom = require('passport-custom');
const CustomStrategy = passportCustom.Strategy;
const LocalStrategy = require('passport-local').Strategy;
const flash = require('connect-flash');
const bcrypt = require('bcrypt');
passport.serializeUser((user, done) => {
    done(null, user.accountID);
});



const compare = async (pass, hash) => {
    return new Promise((resolve, reject) => {
        bcrypt.compare(pass, hash, (err, result) => {
            resolve(result);
        })
    })
}

passport.deserializeUser((id, done) => {
    let sql = 'select * from account where accountID = ' + id;
    connection.query(sql, (err, result) => {
        done(null, result[0]);
    })
});


passport.use('local', new LocalStrategy({ usernameField: 'email', passwordField: 'password', passReqToCallback: true },
    (req, username, password, done) => {
        // console.log(req);
        console.log(username, password);
        let sql = `select * from account where email= ?;`;
        connection.query(sql, [username, password],(err, result) => {
            if (result.length) {
                bcrypt.compare(password, result[0].password, (err, result2) => {
                    if (result2 == true) {
                        done(null, result[0]);
                    } else {
                        console.log('boom');
                        done(null, false, req.flash("error", 'Wrong email or password'));
                    }
                })
            } else {
                console.log('boom');
                done(null, false, req.flash("error", 'Wrong email or password'));
            }
        })
    }
))
