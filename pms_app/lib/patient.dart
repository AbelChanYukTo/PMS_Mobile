import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
// Defining the root widget of the patient page
// Must be created with a string of a patient's name
class PatientPage extends StatefulWidget{
    const PatientPage({super.key,required this.patient});
    // Store the patient's name as an immutable state
    final String patient;
    // Define a method to create a State object for this widget
    // This method is called when the widget is created
    // The State object is where the mutable state for this widget is stored
    State<PatientPage> createState()=> _PatientPageState();}
class _PatientPageState extends State<PatientPage>{

    // Mutable states for storing the patient's and doctor's data
    var patientDetails={};
    var doctorDetails={};

    // Defining a method to fetch the patient's and doctor's data from the server
    void getPatientData() async{
        // Change the <ip_address> to your server's IP address
        // e.g. 192.168.144.240
        var response=await http.get(Uri.parse("http://<ip_address>:3001/patient/${widget.patient}"),
        headers: {"Content-Type": "application/json"});
        if(response.statusCode==200){
            var theData=json.decode(response.body);
            // Store the obtained patient's and doctor's data into the states
            setState((){
                patientDetails=theData["patient"];
                doctorDetails=theData["doctor"];
            });
    }
    }
    // Called when this widget is inserted into the widget tree
    void initState(){
        super.initState();
        // Set the getPatientData() method to be called every second
        // So that the patient's data is updated every second
        Timer(const Duration(seconds:1),getPatientData);
    }
    // Called when the states are changed
    // To build the UI of the patient page
    Widget build(BuildContext context){
        return Scaffold(
            // Similar to the app bar in login page and patients page,
            // but the leading icon is an arrow back icon
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: const Text('Patients Monitoring System',style:TextStyle(color:Colors.white)),
                automaticallyImplyLeading: false,
                // When the icon is pressed, it will return to the patients page
                leading: IconButton(icon: const Icon(Icons.arrow_back),
                onPressed: (){Navigator.of(context).pop();})
            ),
            // The body of the page
            // Its content is a list of widgets in a ListView object
            body: Center(
                child: ListView(
                    // Set the padding on the four sides of the list to be 8 pixels
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                    // The top widget is a text showing the patient's name
                    Container(
                    padding: const EdgeInsets.all(8),
                    child: Text("Patient: ${patientDetails["name"]}", style: const TextStyle(fontSize: 30,color:Colors.indigo))),

                    // The following widgets are a list of cards,
                    // each card for each attribute of the patient
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.indigo,
                            child: ListTile(title: Text("Sex",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["sex"]}",style:TextStyle(color:Colors.white)))
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.pink,
                            child: ListTile(title: Text("Age",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["age"]}",style:TextStyle(color:Colors.white)))
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.indigo,
                        child: ListTile(title: Text("Blood Pressure",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["blood_pressure"]}",style:TextStyle(color:Colors.white)))
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.pink,
                        child: ListTile(title: Text("Blood Type",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["blood_type"]}",style:TextStyle(color:Colors.white)))
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.indigo,
                        child: ListTile(title: Text("ID",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["id"]}",style:TextStyle(color:Colors.white)))
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.pink,
                        child: ListTile(title: Text("Condition",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["condition"]}",style:TextStyle(color:Colors.white)))
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.indigo,
                        child: ListTile(title: Text("Pulse",style:TextStyle(color:Colors.white)),
                        subtitle: Text("${patientDetails["heartbeat_rate"]}",style:TextStyle(color:Colors.white)))
                        )),
                    
                    // The function to show the records of the patient is not implemented yet
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Card(color:Colors.pink,
                        child: ListTile(title: Text("Records",style:TextStyle(color:Colors.white)))
                        ))
                    ])));
}}