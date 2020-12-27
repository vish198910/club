import "package:flutter/material.dart";

class ClubWidget extends StatefulWidget {
  bool isSubscribed;
  final String clubName;
  final String subClubName;
  ClubWidget({this.isSubscribed, this.clubName, this.subClubName});
  @override
  _ClubWidgetState createState() => _ClubWidgetState();
}

class _ClubWidgetState extends State<ClubWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                widget.isSubscribed = !widget.isSubscribed;
              });
            },
            child: Icon(
              Icons.notifications,
              color: widget.isSubscribed ? Colors.blue : Colors.grey,
              size: 30,
            ),
          ),
          title: Text(
            widget.clubName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.subClubName,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
