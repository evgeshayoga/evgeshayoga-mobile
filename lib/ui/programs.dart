import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/drawer_programs_screen.dart';
import 'package:evgeshayoga/ui/program_screen.dart';
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
                    if (programs.containsKey(program.id) && isAvailable(programs[program.id]["availableTill"])) {
                      return _availableProgram(programs, snapshot.value);
                    }
                    return _notAvailableProgram(programs, snapshot.value);
                  },
                ),
              )
            ],
          ),
        ));
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

  Widget _notAvailableProgram(purchases, program) {
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
            )),
//        buttonIfPurchasable(purchases, program),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
        )
      ],
    ));
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
    return null;
  }

  Widget _availableProgram(purchases, program) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
              onTap: () {
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
              )
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

  programsCheck(snapshot) {
    if (!snapshot.value["isActive"] ||
        !isAvailable(user.getPurchases().programs[snapshot.value["id"]]
            ["availableTill"])) {
      return _inactiveProgram();
    } else if (!user
            .getPurchases()
            .programs
            .containsKey(snapshot.value["id"]) ||
        !user.getPurchases().programs[snapshot.value["id"]]["isPurchased"]) {
      return _notAvailableProgram(user.getPurchases().programs, snapshot.value);
    }
    return _availableProgram(user.getPurchases().programs, snapshot.value);
  }

//  Widget dateFormatted(date) {
//    var parsedDate = DateTime.parse(date);
//    var formatter = DateFormat("d.MM.y");
//    String formatted = formatter.format(parsedDate);
//    return Text(
//      "Доступен до " + formatted,
//      style: Style.regularTextStyle,
//    );
//  }
}
