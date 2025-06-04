import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
class SignUpSuccess extends StatefulWidget{
    const SignUpSuccess({super.key,required this.username});
    final String username;
    State<SignUpSuccess> createState()=> _SignUpSuccessState();
}
class _SignUpSuccessState extends State<SignUpSuccess>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
        // Use the title passed to the widget to set the title of the app bar
        // The variable widget refers to its associated MyHomePage widget
        title: Text('Patients Monitoring System', style:TextStyle(color:Colors.white)),
        automaticallyImplyLeading: false),
        body:Center(
        child: Column(
            children: <Widget>[
                Container(padding: const EdgeInsets.all(8),
                child: Text("Sign Up Successful!\nUsername: ${widget.username}",style: TextStyle(fontSize: 24, color:Colors.indigo, fontWeight: FontWeight.bold))),
                ElevatedButton(child: Text("Return to Login Page"),
                onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                }),
            ])
        ));
}}