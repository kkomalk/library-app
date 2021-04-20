const schedule = require('node-schedule');

const cquery = async  (sql,req,res)=>{
    return new Promise((resolve,reject)=>{
        connection.query(sql,(err,result)=>{
            if(err) console.log(err);
            else resolve(result);
        })
    }
    )
}

schedule.scheduleJob('0 0 0 * * *',()=>{
    console.log('doing the job right now.');
})