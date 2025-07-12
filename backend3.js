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
clus=new MongoClient("mongodb+srv://abelchanseefat1230:123456789To1@abelchanyukto.b26hf.mongodb.net/"
        + "?retryWrites=true&w=majority&appName=AbelChanYukTo");
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
    const account = pms.collection("account");
    const result=await account.findOne({ username: username, password: password });
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
    console.log("Received doctor request");
    // get the doctor's data and its patients' data
    async function run(){
        await clus.connect();
        const pms = clus.db("pms");
        const patient = pms.collection("patient");
        const doct=pms.collection("doctor");
        const result=await patient.find({doctor:doctor});
        console.log("Finding patients successful with doctor ID:"+doctor);
        const result2=await doct.findOne({id:doctor});
        console.log("Finding doctor successful with ID: "+doctor);
        var theArr=[];
        for await (const doc of result){
            theArr.push(doc);
        }
        console.log("Pushing completed");
        res.json({patients:theArr,doctor:result2});
        console.log("Response sent");
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
const result2=await doctor.findOne({id:result.doctor});
res.json({patient:result,doctor:result2});}
run();
});
app.post("/signup",(req,res)=>{
    var {doctor_id,full_name,department,username,password}=req.body;
    async function run(){
    await clus.connect();
    const pms = clus.db("pms");
    const doctor = pms.collection("doctor");
    const account=pms.collection("account");
    // check if the username already exists
    const existingUser = await account.findOne({ username: username });
    if (existingUser) {
        console.log("Username already exists");
        res.json({ success: false, message: "Username already exists" });
        return;
    }
    // check if the doctor has already had an account
    const existingAccount = await account.findOne({ id: doctor_id });
    if (existingAccount) {
        console.log("Doctor already has an account");
        res.json({ success: false, message: "Doctor already has an account" });
        return;
    }
    // check if the password is empty
    if (!password || password.trim() === "") {
        console.log("Password cannot be empty");
        res.json({ success: false, message: "Password cannot be empty" });
        return;
    }
    // check if the doctor's ID and name exists
    const existingDoctor = await doctor.findOne({ id: doctor_id, name: full_name, dept: department });
    console.log("Looking for doctor:", {
    id: doctor_id,
    name: full_name,
    dept: department
});
    if (!existingDoctor){
        console.log("Doctor not found");
        res.json({ success: false, message: "Doctor not found" });
        return;
    }
    // insert the new account into the account collection
    const newAccount = {
        username: username,
        password: password,
        id: doctor_id
    };
    await account.insertOne(newAccount);
    console.log("Signup successful");
    res.json({ success: true, username:username,password:password });
    return;
}
run();}
);
// The server listens on the port 3001
app.listen(3001,"0.0.0.0", () => { console.log("Server running") });