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
        var response=await http.get(Uri.parse("http://165.22.191.190:3001/patients/${widget.doctor}"),
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
                    title: const Text("Do you want to logout?",style:TextStyle(color:Colors.indigo)),
                    children: <Widget>[
                        // If the button "Yes" is pressed, the app will remove the dialog
                        // and return to the login page
                        SimpleDialogOption(child:ElevatedButton(
                            style: ButtonStyle(backgroundColor:WidgetStatePropertyAll<Color>(Colors.red)),
                            child: const Text("Yes",style: TextStyle(color: Colors.white)),
                            onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                            })
                            
                        ),
                        // If the button "No" is pressed, the app will just remove the dialog
                        SimpleDialogOption(child:ElevatedButton(
                        child: const Text("No",style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(backgroundColor:WidgetStatePropertyAll<Color>(Colors.indigo)),
                        onPressed: () {
                                Navigator.of(context).pop();
                            })
                            )]
                );}
        );
    }
    // Method to build a dialog for showing the doctor's information
    Future<void> showDoctorInfo(BuildContext context) async{
        return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("Doctor's Information",style:TextStyle(color:Colors.indigo)),
                    content: Text("Name: ${doctorData["name"]}\nDepartment: ${doctorData["dept"]}\nID: ${doctorData["id"]}",
                    style:TextStyle(color:Colors.indigo)),
                    actions: <Widget>[
                        // If the button "OK" is pressed, the dialog will be removed
                        ElevatedButton(
                            child: const Text("OK",style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(backgroundColor:WidgetStatePropertyAll<Color>(Colors.indigo)),
                            onPressed: () {
                                Navigator.of(context).pop();
                            })
                    ],
                );
            }
        );
    }
    // To define the UI layout of this page
    // This method will be rerun once the states are changed
    Widget build(BuildContext context){
        return Scaffold(
            // The app bar is similar to that of the login page
            // But a leading icon button is added to logout
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: const Text('Patients Monitoring System',style:TextStyle(color:Colors.white)),
                automaticallyImplyLeading: false,
                // When the icon button is pressed, the dialog will appear to ask for confirmation
                leading: IconButton(icon: const Icon(Icons.logout),
                onPressed: (){logout(context);}),
                actions: <Widget>[IconButton(icon: Icon(Icons.account_circle,color:Colors.white),
                onPressed:(){showDoctorInfo(context);})]
            ),
            // The body of the page
            body: Center(
                // The widgets are arranged in a column
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Container(
                        padding: const EdgeInsets.all(8),
                        child:Text('Welcome, Dr. ${doctorData["name"]}',style:TextStyle(fontSize: 30,color:Colors.indigo,fontWeight:FontWeight.bold))),
                        // To build a list of cards showing the patients' information
                        Expanded(
                            child: ListView.builder(
                                itemCount: patients.length,
                                itemBuilder: (context, index){
                                    return Card(color:Colors.indigo,
                                    child: Column(children: <Widget>[
                                        ListTile(
                                        title: Text("Name:${patients[index]["name"]}",style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                                        subtitle: Text("Age: ${patients[index]["age"]}\nCondition: ${patients[index]["condition"]}",style:TextStyle(color:Colors.white)),
                                    ),
                                    // A button on each card for viewing the details of the patient
                                    // When the button is pressed, it will navigate to the PatientPage
                                    TextButton(child: Text("View Details",style:TextStyle(color:Colors.white)),
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