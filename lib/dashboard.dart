import 'package:cloud_firestore/cloud_firestore.dart';
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
  var clubs;
  var students;
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
                  child: Text("Tasks"),
                ),
                Text("Feed"),
                Text("Clubs")
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
                  child: ListView.builder(
                itemCount: numberOfClubs,
                itemBuilder: (BuildContext context, int index) {
                  if (clubs[index].data()["name"] != null) {
                    return Container(
                      child: Center(
                        child: Text(
                          clubs[index].data()["name"],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  } else if (numberOfClubs <= 0) {
                    return Container(
                      child: Text("No Clubs here"),
                    );
                  } else {
                    return Container();
                  }
                },
              )),
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
