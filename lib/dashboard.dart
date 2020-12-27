import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/screens/club_posts_widget.dart';
import 'package:club/widgets/club_widget.dart';
import 'package:flutter/material.dart';

import 'services/usermngmt.dart';

class DashboardPage extends StatefulWidget {
  final data;
  DashboardPage({this.data});
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserManagement userObj = new UserManagement();
  String userType = "";
  String userName = "";
  String collectionName = "";
  int numberOfClubs = 0;
  int numberOfStudents = 0;
  List clubs;
  List students;

  void fetchUserInformation() async {
    students = await FirebaseFirestore.instance
        .collection('students')
        .get()
        .then((snapshot) {
      return snapshot.docs;
    });
    numberOfStudents = students.length;
    clubs = await FirebaseFirestore.instance
        .collection("clubs")
        .get()
        .then((snapshot) {
      return snapshot.docs;
    });
    numberOfClubs = clubs.length;

    for (int i = 0; i < students.length; i++) {
      if (students[i].exists) {
        if (students[i].data()["email"] == widget.data.email) {
          collectionName = "students";
        }
      }
    }
    for (int i = 0; i < clubs.length; i++) {
      if (clubs[i].exists) {
        if (clubs[i].data()["email"] == widget.data.email) {
          collectionName = "clubs";
        }
      }
    }

    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.data.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userType = documentSnapshot.data()["type"];
        userName = documentSnapshot.data()["name"];
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });

    setState(() {});
  }

  void addTask() {}

  @override
  void initState() {
    fetchUserInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Tasks",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Feed",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Clubs",
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
            title: ListTile(
              title: Text(
                "Scheduler",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              subtitle: Text(
                userName + " ( " + userType + " ) ",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                    onTap: () {
                      userObj.signOut();
                    },
                    child: Icon(Icons.logout)),
              )
            ],
          ),
          body: TabBarView(
            children: [
              Center(
                  child: Text(
                "Add Tasks",
                style: TextStyle(fontSize: 40),
              )),
              Center(
                  child: Text(
                "Feed",
                style: TextStyle(fontSize: 40),
              )),
              Center(
                  child: ClubPostsWidget(
                      numberOfClubs: numberOfClubs, clubs: clubs)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'What do you want to remember?'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Close",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                  ),
                                  RaisedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          )),
    );
  }
}
