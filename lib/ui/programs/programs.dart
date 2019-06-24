import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/drawer_programs_screen.dart';
import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:url_launcher/url_launcher.dart';

class Programs extends StatefulWidget {
  final String userUid;

  Programs({Key key, this.userUid}) : super(key: key);

  @override
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbUsersReference;
  DatabaseReference dbProgramsReference;
  User user;

  @override
  void initState() {
    super.initState();
    dbUsersReference =
        database.reference().child("users").child(widget.userUid);
    dbProgramsReference = database.reference().child("marathons");
    user = User("", "", "", "");

    dbUsersReference.once().then((snapshot) {
      setState(() {
        user = User.fromSnapshot(snapshot);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var programs = user.getPurchases().programs;
    return Scaffold(
      drawer: drawerProgramScreen(user, context, widget.userUid),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          "ПРОГРАММЫ",
          style: Style.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(242, 206, 210, 1),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Future.value(false);
        },
        child: Column(
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
                  var program = Program.fromSnapshot(snapshot);
                  if (!program.isActive) {
                    return _inactiveProgram();
                  }
                  if (programs.containsKey(program.id) &&
                      isAvailable(programs[program.id]["availableTill"])) {
                    return _availableProgram(programs, snapshot.value);
                  }
                  return _notAvailableProgram(
                      programs, snapshot.value, context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inactiveProgram() {
    return null;
  }

  void _showInactProgDialog(BuildContext context, String programTitle) {
    var alert = new AlertDialog(
      title: Text(
        programTitle,
        textAlign: TextAlign.center,
        style: Style.headerTextStyle,
      ),
      content: Text(
        "Программа не активна",
        textAlign: TextAlign.center,
        style: Style.regularTextStyle,
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

  Widget _notAvailableProgram(purchases, program, BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        ListTile(
            title: Text(
              program["title"],
              textAlign: TextAlign.center,
              style: Style.headerTextStyle,
            ),
            subtitle: Stack(
              children: <Widget>[
                Image.network(
                    "https://evgeshayoga.com" + program["thumbnailUrl"]),
                Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/images/lock.png'),
                ),
              ],
            ),
            onTap: () {
              _unavailableProgDialog(context, program["title"]);
            }),
//        buttonIfPurchasable(purchases, program),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
        )
      ],
    ));
  }

  _unavailableProgDialog(BuildContext context, title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: Style.headerTextStyle,
            ),
            content: Text(
              "Программа не доступна",
              textAlign: TextAlign.center,
              style: Style.regularTextStyle,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  Widget buttonIfPurchasable(purchases, program) {
    if (purchases[program["id"]]["isPurchasable"]) {
      return MaterialButton(
        child: Text(
          "Купить",
          style: Style.regularTextStyle,
        ),
        color: Style.pinkMain,
        onPressed: () async {
          var url =
              'https://evgeshayoga.com/marathons/' + program["id"].toString();
          if (await canLaunch(url)) {
            await launch(url);
          }
        },
      );
    }
    return Container();
  }

  Widget _availableProgram(purchases, program) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
              onTap: () {
//                _showProgressIndicator();
                var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return ProgramScreen(program["title"], program["id"]);
                });
                Navigator.of(context).push(router);
              },
              title: Text(
                program["title"],
                textAlign: TextAlign.center,
                style: Style.headerTextStyle,
              ),
              subtitle: Image.network(
                  "https://evgeshayoga.com" + program["thumbnailUrl"])),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Доступен до " +
                    dateFormatted(purchases[program["id"]]["availableTill"]),
                style: Style.regularTextStyle,
              ))
        ],
      ),
    );
  }
}
