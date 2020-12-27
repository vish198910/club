import 'package:club/widgets/club_widget.dart';
import "package:flutter/material.dart";

class ClubPostsWidget extends StatelessWidget {
  const ClubPostsWidget({
    Key key,
    @required this.numberOfClubs,
    @required this.clubs,
  }) : super(key: key);

  final int numberOfClubs;
  final List clubs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: numberOfClubs,
      itemBuilder: (BuildContext context, int index) {
        if (clubs[index].data()["name"] != null) {
          return ClubWidget(
            isSubscribed: false,
            clubName: clubs[index].data()["name"],
            subClubName: clubs[index].data()["email"],
          );
        } else if (numberOfClubs <= 0) {
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
