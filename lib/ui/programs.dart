import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Programs extends StatefulWidget {
  final String userUid;

  Programs({Key key, this.userUid}) : super(key: key);

  @override
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference dbUsersReference;
  DatabaseReference dbProgramsReference;
  String userName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbUsersReference =
        database.reference().child("users").child(widget.userUid);
    dbProgramsReference = database.reference().child("marathons");

    dbUsersReference.once().then((snapshot) {
      setState(() {
        userName = snapshot.value["name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: new Drawer(
            child: new Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                //green container with user's icon and name
                Container(
                  color: Color.fromRGBO(242, 206, 210, 1),
                  alignment: Alignment.topCenter,
                  height: 250,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                          title: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/images/avatar.png',
                              height: 75,
                            ),
                            minRadius: 60,
                          ),
                        ),
                        Padding(padding: new EdgeInsets.fromLTRB(0, 20, 0, 0)),
                        Text(
                          userName,
                          style: TextStyle(
                            color: Color.fromRGBO(94, 101, 111, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 420,
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  _auth.signOut();
                  print("Signed out");
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
                color: Color.fromRGBO(242, 206, 210, 1),
                child: new Text(
                  "Logout",
                  style: TextStyle(
                    color: Color.fromRGBO(94, 101, 111, 1),
                    fontSize: 16.9,
                  ),
                ),
              ),
            )
          ],
        )),
        appBar: AppBar(
          title: Text(
            "ПРОГРАММЫ",
            style: TextStyle(
                fontFamily: "GarageGothic",
                fontSize: 30,
                color: Color.fromRGBO(94, 101, 111, 1)),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(242, 206, 210, 1),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                query: dbProgramsReference,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                      ),
                      title: Text(snapshot.value["title"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey,
                          )),
                      subtitle: Image.network("https://evgeshayoga.com"+snapshot.value["thumbnailUrl"])
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
