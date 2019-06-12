import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/profile_screen.dart';
import 'package:evgeshayoga/ui/program_screen.dart';
import 'package:evgeshayoga/ui/purchases_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
  User user;

  @override
  void initState() {
    super.initState();
    dbUsersReference =
        database.reference().child("users").child(widget.userUid);
    dbProgramsReference = database.reference().child("marathons");
    user = User("","","","");

    dbUsersReference.once().then((snapshot) {
      setState(() {
        user = User.fromSnapshot(snapshot);
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
                          user.userName,
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
            Padding(
            padding: EdgeInsets.only(top: 20),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Профиль",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () {
                    var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return ProfileScreen(user);
                    });
                    Navigator.of(context).push(router);
                  },
                ),
                ListTile(
                  title: Text(
                    "Мои покупки",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  onTap: () {
                    var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return PurchasesScreen(user);
                    });
                    Navigator.of(context).push(router);
                  },
                )
              ],
            ),
            Container(
              height: 250,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                query: dbProgramsReference,
                sort: (sa, sb) {
                  return sb.value["id"] - sa.value["id"];
                },
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  if (snapshot.value["isActive"] != true) {
                    return _inactiveProgram(
                        context,
                        snapshot.value["title"],
                        "https://evgeshayoga.com" +
                            snapshot.value["thumbnailUrl"]);
                  } else if (!user.getPurchases().programs.containsKey(snapshot.value["id"]) ||
                      !user.getPurchases().programs[snapshot.value["id"]]["isPurchased"]) {
                    return _notPurchasedProgram(snapshot.value);
                  } else
                    return _purchasedProgram(user.getPurchases().programs, snapshot.value);
                },
              ),
            )
          ],
        ));
  }

  Widget _inactiveProgram(
      BuildContext context, String programTitle, String thumbnailUrl) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Opacity(
            opacity: 0.4,
            child: ListTile(
              title: Text(programTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.withOpacity(0.7),
                  )),
              subtitle: Image.network(thumbnailUrl),
              onTap: () {
                print(thumbnailUrl);
                _showInactProgDialog(
                  context,
                  programTitle,
                );
              },
            ),
          ),
        ),
        Divider(
          height: 7,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  void _showInactProgDialog(BuildContext context, String programTitle) {
    var alert = new AlertDialog(
      title: Text(
        programTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Программа не активна",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 17,
        ),
      ),
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

  Widget _notPurchasedProgram(program) {
    return Card(
        child: Column(
      children: <Widget>[
        ListTile(
            title: Text(program["title"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                )),
            subtitle: Stack(
              children: <Widget>[
                Image.network(
                    "https://evgeshayoga.com" + program["thumbnailUrl"]),
                Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/images/lock.png'),
                ),
              ],
            )),
        MaterialButton(
          child: Text("Купить",
              style: TextStyle(
                height: 1.5,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              )),
          color: Color.fromRGBO(242, 206, 210, 1),
          onPressed: () async {
            var url =
                'https://evgeshayoga.com/marathons/' + program["id"].toString();
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
        )
      ],
    ));
  }

  Widget _purchasedProgram(purchases, program) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
              onTap: () {
                var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return ProgramScreen(program);
                });
                Navigator.of(context).push(router);
              },
              title: Text(program["title"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  )),
              subtitle: Image.network(
                  "https://evgeshayoga.com" + program["thumbnailUrl"])),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: dateFormatted(purchases[program["id"]]["availableTill"])
//            Text("Available till " + purchases["marathons"][index]["availableTill"],
//                style: TextStyle(
//                  height: 1.5,
//                  fontSize: 17,
//                  fontWeight: FontWeight.w400,
//                  color: Colors.blueGrey,
//                ) ),
              )
        ],
      ),
    );
  }

  Widget dateFormatted(date) {
    var parsedDate = DateTime.parse(date);
    var formatter = DateFormat("d.MM.y");
    String formatted = formatter.format(parsedDate);
    return Text("Доступен до " + formatted,
        style: TextStyle(
          height: 1.5,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Colors.blueGrey,
        ));
  }
}
