import 'package:flutter/material.dart';

import './allusers.dart';
import './admin.dart';

import 'services/usermngmt.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserManagement userObj = new UserManagement();

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
            title: Text('Scheduler'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                "Tasks",
                style: TextStyle(fontSize: 40),
              )),
              Center(
                  child: Text(
                "Feed",
                style: TextStyle(fontSize: 40),
              )),
              Center(
                  child: Text(
                "Clubs",
                style: TextStyle(fontSize: 40),
              )),
            ],
          )),
    );
  }
}
