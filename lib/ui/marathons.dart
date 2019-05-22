import 'package:evgeshayoga/ui/login.dart';
import 'package:evgeshayoga/ui/marathon_poweryoga.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Marathons extends StatelessWidget {
  final String name;
  final String familyName;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = GoogleSignIn();


  @override
  Marathons({Key key, this.name, this.familyName}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(
          child: new Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              //green container with user's icon and name
              Container(
                color: Colors.green.shade400,
                alignment: Alignment.topCenter,
                height: 250,
                child: Center(
                    child: Column(
                  children: <Widget>[
                    ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                      title: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                        minRadius: 60,
                      ),
                    ),
                    Padding(padding: new EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    Text(
                      "$name $familyName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
          Container(
            height: 420,
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
                onPressed: (){
                  _auth.signOut();
                  _googleSignin.signOut();
                  print("Signed out");
//                  var router = new MaterialPageRoute(builder: (BuildContext context) {
//                    return Login();
//                  });
//                  Navigator.of(context).push(router);
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName('/'));
                },
                color: Colors.white,
                child: new Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16.9),
                )
            ),
          )
        ],
      )),
      appBar: AppBar(
        title: Text("Marathons"),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    _showMarathonDialog(context);
                  },
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    'Марафон для начинающих',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey),
                  ),
                  subtitle:
                      Image.asset('assets/images/marathon_beginners_cover.png'),
                  isThreeLine: true,
                  leading: Icon(
                    Icons.event_available,
                    color: Colors.blueGrey,
                  ),
                ),
                Divider(
                  height: 7,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  onTap: () {
                    var router =
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return PowerYoga();
                    });
                    Navigator.of(context).push(router);
                  },
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    'PowerYoga',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey),
                  ),
                  subtitle:
                      Image.asset('assets/images/marathon_poweryoga_cover.jpg'),
                  leading: Icon(
                    Icons.event_available,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showMarathonDialog(BuildContext context) {
  var alert = new AlertDialog(
    title: Text("Марафон для начинающих"),
    content: Text("Запись на марафон закрыта"),
    actions: <Widget>[
      FlatButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}
