var http=require("http");
var fs=require("fs");
var ws=require("ws");
var url=require("url");
http.createServer((req,res)=>{
    fs.readFile("./php.html",(err,data)=>{
        res.writeHead(200,{"Content-Type":"text/html; charset=utf-8"});
        res.write(data);
        res.end();});
}).listen(5500,"165.22.191.190");
var wss=new ws.Server({port:5501,host:"165.22.191.190"});
wss.on("connection",function (cli){
    cli.on("message",function (data){
        fs.appendFile("database.txt",data,(err)=>{
            if (err){console.log("Append File Error!");}
        })});})