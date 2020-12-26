import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/sign_up.dart';
import 'package:flutter/material.dart';
import './allusers.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  int _radioValue = 0;
  String role = "Student";

  void _handleRadioValueChange(int value) {
    //0 denotes Student
    //1 denotes Club
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          role = "Student";
          break;
        case 1:
          role = "Club";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Scheduler'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
                      labelText: "Email",
                    ),
                    controller: emailController,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Enter your Password",
                      labelText: "Password",
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Center(
                    child: Text(
                  "What resembles you the most?",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text(
                    "Student",
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  new Text(
                    'Club',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        if (_radioValue == 0) {
                          var usersType =
                              users.doc("students").collection("students");
                          usersType
                              .add({
                                'name': userCredential.user.displayName,
                                'email': userCredential.user.email, // John Doe
                                'uid': userCredential.user.uid,
                                'type': role // Stokes and Sons // 42
                              })
                              .then((value) => print("User Added"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                        } else {
                          var usersType =
                              users.doc("clubs").collection("clubs");
                          usersType
                              .add({
                                'name': userCredential.user.displayName,
                                'email': userCredential.user.email, // John Doe
                                'uid': userCredential.user.uid,
                                'type': role // Stokes and Sons // 42
                              })
                              .then((value) => print("User Added"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    elevation: 5.0,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('Sign up'),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Already a user? Login Here",
                  style: TextStyle(fontSize: 15),
                )),
              ),
              ButtonTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SignUpPage();
                      }));
                    },
                    elevation: 5.0,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('Login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
