const nodemailer = require('nodemailer');
const schedule = require('node-schedule');
const keys = require('./keys');
const cquery = async  (sql,req,res)=>{
    return new Promise((resolve,reject)=>{
        connection.query(sql,(err,result)=>{
            if(err) console.log(err);
            else resolve(result);
        })
    }
    )
}

schedule.scheduleJob('0 0 0 * * *',async ()=>{
    let users = await cquery(`select * user;`);
    let len = users.length;
    for(let i=0;i<len;i++){
        await cquery(`call updateFine(${users[i].userID});`);
    }
    console.log('Fines Updated!');
})

schedule.scheduleJob('0 0 0 * * *', async ()=>{
    let requests = await cquery(`select * from holdRequest;`);
    let len =requests.length;
    for(let i=0;i<len;i++){
        await cquery(`call approveHold(${requests[i].userID},${requests[i].ISBN},@copyID,@dueDate,@status);`);
        let status = await cquery(`select @status;`);
        console.log(status);
        if(status[0]['@status'] == 1){
            let email = await cquery(`select email from user where userID = ${requests[i].userID};`);
            let name = await cquery(`select title from book where ISBN=${requests[i].ISBN};`)
            let duedate = await cquery(`select @dueDate;`);
            let copyid = await cquery(`select @copyID;`);
            let subject = "Your Hold Request was approved."
            let body = `The hold request that you had registered for the book '${name[0].title}' was approved. Please collect it from the library before ${duedate[0]['@dueDate']}. Your copyID is ${copyid[0]['@copyID']}.`;
            console.log(subject,body,email);
            mail(subject,body,email[0].email);
        }
    }
})


const mail = async (subject,body,email)=>{

    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: keys.ac_user,
            pass: keys.ac_pass
        },
    });
    var mailOptions = {
        from: 'no-reply@gmail.com',
        to: email,
        subject,
        html: body
    };
    
    transporter.sendMail(mailOptions, (err, info) => {
        if (err) { throw err; }
        else {
            console.log("email sent:" + info.response);
        }
    })
}
