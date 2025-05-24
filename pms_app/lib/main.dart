import 'package:flutter/material.dart';
import "/patients.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

// Entry point of the app execution
void main() {
  runApp(const MyApp());
}

// Defining the root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Defining the user interface layout of the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patients Monitoring System',
      // This is the theme of your application.
      theme: ThemeData(
        // Set the color of the app bar to purple
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      // Set the home page of the app
      home: const MyHomePage(title: 'Patients Monitoring System'),
    );
  }
}
// Define the home page widget
// title is a required parameter when constructing this widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // The immutable state of this widget
  final String title;

  // Define a method to create a State object for this widget
  // This method is called when the widget is created
  // The State object is where the mutable state for this widget is stored
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Define the State class for the MyHomePage widget
class _MyHomePageState extends State<MyHomePage> {

// The GlobalKey to build a form and to uniquely identify it
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// The TextEditingController objects to get and change the text in their associated text boxes
final myController = TextEditingController();
final myController2 = TextEditingController();

// Prepared for showing error messages
String error_message="";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
      // Set the app bar of the page
      appBar: AppBar(
        // Set the background color of the app bar to the color defined in the colorScheme
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Use the title passed to the widget to set the title of the app bar
        // The variable widget refers to its associated MyHomePage widget
        title: Text(widget.title, style:TextStyle(color:Colors.white)),
      ),
      // Set the body of the page
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        // A form widget for login
        // containing a column of text fields and a button
        child: Form(key: _formKey,
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Please login',style: TextStyle(fontSize: 30, color:Colors.indigo)),

            // Text Boxes for entering username and password
            TextFormField(decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              border: OutlineInputBorder(),
            ),
            // Use myController to get and change the text in the text box
            controller: myController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username cannot be empty';
              }
              return null;
            },),
            TextFormField(decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border: OutlineInputBorder(),
            ),
            controller: myController2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              return null;
            },),
            // Button to submit the form for login
            ElevatedButton(
              // Define the function to be called when the button is pressed
              onPressed: () async{
              // Get the data from the text boxes
              // Store it in a JSON format
              var data = json.encode({
                "username": myController.text,
                "password": myController2.text
              });
              // Send a POST request to the backend server
              // Change the <ip_address> to your server's IP address
              // e.g. 192.168.144.240
              var response=await http.post(Uri.parse("http://<ip_address>:3001/login"),
              // Set the headers to specify the content type as JSON
              headers:{"Content-Type": "application/json"},
              // Send the pair of inputted username and password as the request's body
              body:data);
              // When received a response, store its body as a JSON object in theData
              var theData=json.decode(response.body);
              // Check if the login is successful
              // If successful, navigate to the patients page
              // And clear the text boxes
                if(theData["success"]==true){
                  setState((){
                  error_message="";
                  myController.clear();
                  myController2.clear();
                });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PatientsPage(doctor: "${theData["doctor"]["name"]}",)));
                }
                // If login is not successful, show an error message at the bottom
                else{setState((){
                  error_message="Username or password incorrect";
                });
                }
            },
            // Set the text shown on the button
              child: const Text('Login',style: TextStyle(fontSize: 20,color:Colors.white)),
              style: ButtonStyle(backgroundColor:WidgetStatePropertyAll<Color>(Colors.pink))
            ),
            // The widget for showing the error message
            Text("${error_message}",style: TextStyle(fontSize: 25,color: Colors.red))
          ]
        ))
      )
      );
  }
}
