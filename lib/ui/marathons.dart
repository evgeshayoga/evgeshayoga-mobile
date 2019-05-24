import 'package:evgeshayoga/models/marathons_data.dart';
import 'package:evgeshayoga/ui/login.dart';
import 'package:evgeshayoga/ui/marathon_card.dart';
import 'package:evgeshayoga/ui/marathon_poweryoga.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                        "$name $familyName",
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
                _googleSignin.signOut();
                print("Signed out");
//                  var router = new MaterialPageRoute(builder: (BuildContext context) {
//                    return Login();
//                  });
//                  Navigator.of(context).push(router);
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              color: Color.fromRGBO(242, 206, 210, 1),
              child: new Text(
                "Logout",
                style: TextStyle(
                    color: Color.fromRGBO(94, 101, 111, 1), fontSize: 16.9),
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
      body: Center(
        child: ListView.builder(
          itemCount: MarathonData.marathons.length,
          itemBuilder: (BuildContext context, int index) {
            var marathon = MarathonData.marathons[index];
            return MarathonCard(marathon);
          },
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
