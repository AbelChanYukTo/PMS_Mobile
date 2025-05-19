const express = require("express")
const cors = require("cors")
const { MongoClient } = require("mongodb");
const app = express()

// To allow CORS
app.use(cors())
app.use(express.json());

// To connect to the online cloud MongoDB cluster
// If any error is thrown when trying to connect to the MongoDB cloud,
// it will try to connect again automatically
var clus;
while (true){try{
clus=new MongoClient("mongodb://localhost:27017");
    break;}
catch(err){}}
console.log("MongoDB Connected");

// When it receives a login request
app.post("/login", (req, res) => {
    console.log("Received login request");
    var { username, password } = req.body;
    // check if the username and password pair exists
    async function run(){
    await clus.connect();
    const pms = clus.db("pms");
    const doctor = pms.collection("doctor");
    const result=await doctor.findOne({ username: username, password: password });
    // If exists, the response will include the corresponding doctor's information
    if (result){
        console.log("Login successful");
        res.json({success:true,doctor:result});
    }
    // If not, the response will indicate that the login fails
    else{
        console.log("Login failed "+JSON.stringify(req.body));
        res.status(401).json({success:false,message:"invalid"});
    }
}
run();
}
);

// When it receives a request for getting the information of the patients which the specified doctor manages
app.get("/patients/:doctor", (req, res) => {
    var doctor = req.params.doctor;
    // get the doctor's data and its patients' data
    async function run(){
        await clus.connect();
        const pms = clus.db("pms");
        const patient = pms.collection("patient");
        const doct=pms.collection("doctor");
        const result=await patient.find({doctor:doctor});
        const result2=await doct.findOne({name:doctor});
        var theArr=[];
        for await (const doc of result){
            theArr.push(doc);
        }
        res.json({patients:theArr,doctor:result2});
    }
    run();
});

// When the request from patient page is received
app.get("/patient/:pat", (req, res) => {
    var patient = req.params.pat;
    // get the specified patient's data and its doctor's data
    async function run(){
    await clus.connect();
const pms=clus.db("pms");
const patcol=pms.collection("patient");
const doctor=pms.collection("doctor");
const result=await patcol.findOne({name:patient});
const result2=await doctor.findOne({name:result.doctor});
res.json({patient:result,doctor:result2});}
run();
});

// The server listens on the port 3001
app.listen(3001,"192.168.144.240", () => { console.log("Server running") });