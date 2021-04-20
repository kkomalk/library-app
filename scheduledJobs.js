const nodemailer = require('nodemailer');
const schedule = require('node-schedule');
const keys = require('./keys');
const cquery = async  (sql,)=>{
    return new Promise((resolve)=>{
        connection.query(sql,(err,result)=>{
            if(err) console.log(err);
            else resolve(result);
        })
    }
    )
}

schedule.scheduleJob('0 0 2 * * *', async ()=>{
    let copies=await cquery(`select * from bookCopies;`);
    let len = copies.length;
    for(let i=0;i<len;i++){
        await cquery(`call cancelHold('${copies[i].ISBN}',${copies[i].copyID},@status);`);
        let status = await cquery(`select @status;`);
        if(status[0]['@status']==1){
            console.log('hold revoked');
        }else{
            console.log('hold not revoked');
        }
    }
})

schedule.scheduleJob('0 0 0 * * *', async ()=>{
    let users = await cquery(`select userID from bookCopiesUser;`);
    let prev=-1;
    let len=users.length;
    for(let i =0 ;i<len;i++){
        if(prev==users[i].userID){
            continue;
        }
        let email = await cquery(`select email from user where userID=${users[i].userID};`);
        let temp = await cquery(`call emailDetails(${users[i].userID},@unpaidFine);`);
        // console.log(temp);
        let fine = await cquery(`select @unpaidFine;`);
        fine = fine[0]['@unpaidFine'];
        let tlen=temp[0].length;
        // console.log(tlen);
        let mess="";
        for(let j=0;j<tlen;j++){
            let action = temp[0][j].action;
            let cur = temp[0][j];
            if(action == 'hold'){
                mess+=`<p>Your hold request for the book '${cur.title}', ISBN: ${cur.ISBN}, copyID: ${cur.copyID} has expired on ${cur.dueDate}. Your unpaid fines are Rs. ${fine}.</p>`;
            }else if(action == 'loan&hold'){
                mess+=`<p>Your loan&hold on the book '${cur.title}', ISBN: ${cur.ISBN}, copyID: ${cur.copyID} has expired on ${cur.dueDate}. Please return it to the library as soon as possible to avoid getting fined. Your unpaid fines are Rs. ${fine}.</p>`;
            }else if(action == 'loan'){
                mess+=`<p>Your loan on the book '${cur.title}', ISBN: ${cur.ISBN}, copyID: ${cur.copyID} has expired on ${cur.dueDate}. Please renew it or return it to library as soon as possible to avoid getting fined. Your unpaid fines are Rs. ${fine}.</p>`;
            }
            // mail('Due Date Expired',mess,cur.email);
        }
        mail('Due Date Expired',mess,email[0].email);
        prev=users[i].userID;
    }
})

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
