import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../login_page.dart';
import '../dashboard.dart';
import '../admin.dart';

class UserManagement {
  BehaviorSubject currentUser = BehaviorSubject<String>();

  Widget handleAuth() {
    return new StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.uid);
          currentUser.add(snapshot.data.uid);
          return DashboardPage();
        }
        return LoginPage();
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  authorizeAdmin(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .get()
        .then((cloudDocs) {
      if (cloudDocs.docs[0].exists) {
        if (cloudDocs.docs[0].data()["role"] == 'admin') {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new AdminPage()));
        } else {
          print('Not Authorized');
        }
      }
    });
  }
}
