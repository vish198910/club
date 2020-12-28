import 'package:club/widgets/club_widget.dart';
import "package:flutter/material.dart";

class ClubPostsWidget extends StatefulWidget {
  ClubPostsWidget(
      {this.numberOfClubs, this.clubs, this.email, this.collectionName});
  final int numberOfClubs;
  final List clubs;
  final String email;
  final String collectionName;
  @override
  _ClubPostsWidgetState createState() => _ClubPostsWidgetState();
}

class _ClubPostsWidgetState extends State<ClubPostsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.numberOfClubs,
      itemBuilder: (BuildContext context, int index) {
        if (widget.clubs[index].data()["name"] != null) {
          return ClubWidget(
            isSubscribed: false,
            clubName: widget.clubs[index].data()["name"],
            subClubName: widget.clubs[index].data()["email"],
            email: widget.email,
            collectionName: widget.collectionName,
            emailToSubscribe: widget.clubs[index].data()["email"],
          );
        } else if (widget.numberOfClubs <= 0) {
          return Container(
            child: Text("No Clubs here"),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
