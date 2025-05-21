import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
import "/patient.dart";

// The root widget of the patients page
// Must be created with a string of a doctor's name
class PatientsPage extends StatefulWidget{
    const PatientsPage({super.key,required this.doctor});

    // The immutable states of this widget
    final String doctor;
    // Define a method to create a State object for this widget
    // This method is called when the widget is created
    // The State object is where the mutable state for this widget is stored
    State<PatientsPage> createState()=> _PatientsPageState();
}
// The State class for the PatientsPage widget
class _PatientsPageState extends State<PatientsPage>{
    /* Sample data for references:
    var patients=[{"name":"John Doe","age":30,"condition":"Healthy"},
    {"name":"Jane Smith","age":25,"condition":"Flu"},
    {"name":"Sam Wilson","age":40,"condition":"Diabetes"},
    {"name":"Peter Parker","age":20,"condition":"Healthy"},
    {"name":"Bruce Wayne","age":35,"condition":"Heart Disease"}];*/

    // Mutable states
    // For storing the list of patients and the doctor's data
    var patients=[];
    var doctorData={};

    // Defining a method to fetch the patients' and doctor's data from the server
    void getPatientsData() async{
        // Change the <ip_address> to your server's IP address
        // e.g. 192.168.144.240
        var response=await http.get(Uri.parse("http://<ip_address>:3001/patients/${widget.doctor}"),
        headers: {"Content-Type": "application/json"});
        if(response.statusCode==200){
            var theData=json.decode(response.body);
            // Store the obtained patients' and doctor's data into the states
            setState((){
                patients=theData["patients"];
                doctorData=theData["doctor"];
            });
    }}

    // Called when this widget is inserted into the widget tree
    void initState(){
        super.initState();
        // Set the getPatientsData() method to be called every second
        // So that the patients' data is updated every second
        Timer(const Duration(seconds:1),getPatientsData);
    }

    // Method to show a dialog for logging out
    Future<void> logout(BuildContext context) async{
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
                return SimpleDialog(
                    title: const Text("Do you want to logout?"),
                    children: <Widget>[
                        // If the button "Yes" is pressed, the app will remove the dialog
                        // and return to the login page
                        SimpleDialogOption(
                            child: const Text("Yes",style: TextStyle(color: Colors.red)),
                            onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                            }
                        ),
                        // If the button "No" is pressed, the app will just remove the dialog
                        SimpleDialogOption(
                            child: const Text("No",style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                                Navigator.of(context).pop();
                            })]
                );}
        );
    }

    // To define the UI layout of this page
    // This method will be rerun once the states are changed
    Widget build(BuildContext context){
        return Scaffold(
            // The app bar is similar to that of the login page
            // But a leading icon button is added to logout
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text('Patients Monitoring System'),
                automaticallyImplyLeading: false,
                // When the icon button is pressed, the dialog will appear to ask for confirmation
                leading: IconButton(icon: const Icon(Icons.logout),
                onPressed: (){logout(context);})
            ),
            // The body of the page
            body: Center(
                // The widgets are arranged in a column
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Text('Welcome, Dr. ${widget.doctor}'),
                        // To build a list of cards showing the patients' information
                        Expanded(
                            child: ListView.builder(
                                itemCount: patients.length,
                                itemBuilder: (context, index){
                                    return Card(child: Column(children: <Widget>[
                                        ListTile(
                                        title: Text("Name:${patients[index]["name"]}"),
                                        subtitle: Text("Age: ${patients[index]["age"]}\nCondition: ${patients[index]["condition"]}"),
                                    ),
                                    // A button on each card for viewing the details of the patient
                                    // When the button is pressed, it will navigate to the PatientPage
                                    TextButton(child: Text("View Details"),
                                    onPressed:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PatientPage(patient: "${patients[index]["name"]}")));

                                    })
                                    ])
                                    );
                                }
                            )
                        )
                    ],
                ),
            ),
        );
    }
}