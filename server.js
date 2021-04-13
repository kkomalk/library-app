const express = require("express");
const cors = require("cors");
const homerouter = require('./routes/home');
require("dotenv").config();

const app = express();
app.use(cors());
const port = process.env.PORT || 5000;

app.use(function (req, res, next) {
	res.header("Access-Control-Allow-Origin", "*");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	next();
});
app.use(express.json());

app.use("/",homerouter);

app.listen(port, () => {
	console.log("Server is running at port : ", port);
});
