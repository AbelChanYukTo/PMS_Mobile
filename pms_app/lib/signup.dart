import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "/signupsuccess.dart";
import 'dart:async';
import 'dart:convert';
class SignUp extends StatefulWidget{
    const SignUp({super.key});
    State<SignUp> createState()=> _SignUpState();
}
class _SignUpState extends State<SignUp>{
    // The variable for showing error messages
    var error_message="";

    // The controllers for getting and changing the text in the text fields
    final doctorIdController=TextEditingController();
    final fullNameController=TextEditingController();
    final departmentController=TextEditingController();
    final usernameController=TextEditingController();
    final passwordController=TextEditingController();

    // The variable for controlling whether the inputted password is obscured or not
    bool obscured=true;

    // The method to build the layout of the SignUp page
    // This method is called when the page is created
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(
        // Set the background color of the app bar to the color defined in the colorScheme
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Use "Patients Monitoring System" as the title of the app bar
        // The title text color is set to white
        title: Text('Patients Monitoring System', style:TextStyle(color:Colors.white)),
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.arrow_back),
                onPressed: (){Navigator.of(context).pop();})
      ),
      body:Center(
        child: ListView(
            children: <Widget>[
                    Container(
                    padding: const EdgeInsets.all(8),
                    child: Text("Sign Up", style: const TextStyle(fontSize: 30,
                    color:Colors.indigo,
                    fontWeight:FontWeight.bold))),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text("Please fill in the details below to create an account.",
                        style: const TextStyle(fontSize: 16,color:Colors.indigo))
                    ),
                    Form(
                    child: Column(
                        children: <Widget>[
                    // ID, full name, department of the doctor must be entered
                    // so that the system can check if the user is eligible to create an account
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text("Doctor ID:",
                        style: const TextStyle(fontSize: 16,color:Colors.indigo))
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Your Doctor ID',
                            border: OutlineInputBorder()),
                            controller: doctorIdController),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text("Full Name:",
                        style: const TextStyle(fontSize: 16,color:Colors.indigo))
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Your Full Name',
                            border: OutlineInputBorder()),
                            controller: fullNameController),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text("Department:",
                        style: const TextStyle(fontSize: 16,color:Colors.indigo))
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Your Department',
                            border: OutlineInputBorder()),
                            controller: departmentController),
                    // For entering the username and password to be set
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text("Set your account's username:",
                        style: const TextStyle(fontSize: 16,color:Colors.indigo))
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Your Username',
                            border: OutlineInputBorder()),
                            controller: usernameController),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text("Set your account's password:",
                        style: const TextStyle(fontSize: 16,color:Colors.indigo))
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Your Password',
                            // To allow the inputted password to be hidden or shown
                            // when the user clicks on the eye icon
                            suffixIcon: IconButton(
                                icon: Icon(obscured ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                    setState(() {
                                        obscured = !obscured; // Toggle the obscured state
                                    });
                                },
                            ),
                            border: OutlineInputBorder()),
                            obscureText: obscured,
                            controller: passwordController),
                        // The submit button to confirm the sign up
                    ElevatedButton(onPressed:() async{
                        // Put the inputs into a JSON object
                        // and preparing to send it to the server as a request body
                        var data=json.encode({
                            "doctor_id":doctorIdController.text,
                            "full_name":fullNameController.text,
                            "department":departmentController.text,
                            "username":usernameController.text,
                            "password":passwordController.text
                        });
                        var response=await http.post(
                            // Change the <ip_address> to your server's IP address
                            // e.g. 192.168.118.240
                            Uri.parse("http://<ip_address>:3001/signup"),
                            headers:{"Content-Type": "application/json"},
                            body:data);
                        // When a response is received, decode the response body
                        var theData=json.decode(response.body);
                        // If the response indocates that the sign up is successful,
                        if(theData["success"]==true){
                        // To ensure that the error message is cleared
                        setState((){
                            error_message="";
                        });
                        // Clear the text fields for security
                        doctorIdController.clear();
                        fullNameController.clear();
                        departmentController.clear();
                        usernameController.clear();
                        passwordController.clear();
                        // Navigate to the page indicating that the sign up is successful
                        // and that page will show the username of the new account
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpSuccess(username: theData["username"])));
                        }
                        // If the sign up is not successful, show the corresponding error message
                        else{
                            setState((){
                                error_message="${theData["message"]}\nPlease try again.";
                            });
                        }
                    },
                    // Set the button's text to be white and the background color to pink
                    child: const Text("Confirm",
                    style: TextStyle(fontSize: 16,color:Colors.white)),
                    style: ButtonStyle(backgroundColor:WidgetStatePropertyAll<Color>(Colors.pink)))
                    ]
                    )),
                    // A container of text to show the error message
                    Container(padding: const EdgeInsets.all(8),
                    child:Text("${error_message}",
                    style: TextStyle(fontSize: 16, color:Colors.red)))
                    ]
        )
      )
        );
    }
}