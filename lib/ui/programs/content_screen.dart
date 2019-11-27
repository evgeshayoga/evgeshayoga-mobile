import 'dart:convert';
import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/components/drawer_programs_screen.dart';
import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:evgeshayoga/ui/programs/yoga_online.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/ui/programs/yoga_online.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ContentScreen extends StatefulWidget {
  final String userUid;

  ContentScreen({Key key, this.userUid}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  static const int tabletBreakpoint = 600;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbUsersReference;
  DatabaseReference dbProgramsReference;
  User user;
  Map<String, dynamic> userProgramsStatuses;

  @override
  void initState() {
    super.initState();
    dbUsersReference =
        database.reference().child("users").child(widget.userUid);
    dbProgramsReference = database.reference().child("marathons");
    user = User("", "", "", "");

    dbUsersReference.once().then((snapshot) {
      getUserProgramsStatuses(widget.userUid).then((statuses) {
        setState(() {
          user = User.fromSnapshot(snapshot);
          userProgramsStatuses = statuses;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;
    var isLandscape = true;
    if (orientation == Orientation.portrait &&
        shortestSide < tabletBreakpoint) {
      isLandscape = false;
    }

    var programs = user.getPurchases().programs;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: drawerProgramScreen(user, context, widget.userUid, isLandscape),
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
          title: Image.asset(
            'assets/images/logo_white.png',
//            'assets/images/logo.png',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
            height: 35,
          ),
          bottom: TabBar(
            indicatorColor: Style.pinkDark,
            unselectedLabelColor: Colors.white,
            labelColor: Style.blueGrey,
            tabs: [
              Tab(
                text: "Программы",
//                icon: new Icon(Icons.audiotrack),
              ),
//              Tab(
//                text: "Йога-онлайн",
////                icon: new Icon(Icons.beach_access),
//              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(242, 206, 210, 1),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: TabBarView(
            children: <Widget>[
              Programs(
                userUid: widget.userUid,
              ),
//              YogaOnline(),
            ],
          ),
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

  Widget _notAvailableProgram(
      purchases, program, BuildContext context, isLandscape) {
    String thumbnailUrl = program["thumbnailUrl"];
    Text title = Text(
      program["title"],
      textAlign: TextAlign.center,
      style: Style.headerTextStyle,
    );
    return Container(
//      height: MediaQuery.of(context).size.height - 80,
      child: Card(
        child: GestureDetector(
          onTap: () {
            _unavailableProgDialog(context, program["title"]);
          },
          child: isLandscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          title,
                          Text(
                            "Программа недоступна ",
                            style: Style.regularTextStyle,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _notAvailableProgramStack(thumbnailUrl),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    ListTile(
                      title: title,
                      subtitle: _notAvailableProgramStack(thumbnailUrl),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _notAvailableProgramStack(thumbnailUrl) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
      child: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Image.network("https://evgeshayoga.com" + thumbnailUrl)),
          Container(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.5,
              child: Icon(
                Icons.lock,
                color: Style.blueGrey,
                size: 150.0,
              ),
            ),
          ),
        ],
      ),
    );
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
          "Программа недоступна",
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

//  Widget buttonIfPurchasable(purchases, program) {
//    if (purchases[program["id"]]["isPurchasable"]) {
//      return MaterialButton(
//        child: Text(
//          "Купить",
//          style: Style.regularTextStyle,
//        ),
//        color: Style.pinkMain,
//        onPressed: () async {
//          var url =
//              'https://evgeshayoga.com/marathons/' + program["id"].toString();
//          if (await canLaunch(url)) {
//            await launch(url);
//          }
//        },
//      );
//    }
//    return Container();
//  }

  Widget _availableProgram(date, program, isLandscape) {
    ConstrainedBox programThumbnail = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
      child: Container(
        alignment: Alignment.center,
        child: Image.network(
          "https://evgeshayoga.com" + program["thumbnailUrl"],
        ),
      ),
    );

    Text title = Text(
      program["title"],
      textAlign: TextAlign.center,
      style: Style.headerTextStyle,
    );

    return Container(
//      height: MediaQuery.of(context).size.height -80,
      child: Card(
        child: GestureDetector(
          onTap: () {
            var router = new MaterialPageRoute(builder: (BuildContext context) {
              return ProgramScreen(program["title"], program["id"]);
            });
            Navigator.of(context).push(router);
          },
          child: isLandscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          title,
                          Text(
                            "Доступен до " + dateFormatted(date),
                            style: Style.regularTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: programThumbnail,
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    ListTile(title: title, subtitle: programThumbnail),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Доступен до " + dateFormatted(date),
                        style: Style.regularTextStyle,
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getUserProgramsStatuses(String uid) async {
  var response = await http.get(
    "https://evgeshayoga.com/api/users/" + uid + "/marathons",
  );
  Map<String, dynamic> data = json.decode(response.body);
  String error = data["error"];
  if (error != null) {
    throw new Exception(error);
  }
  return data;
}

bool isViewable(Map userProgramsStatuses, int programId) {
  if (userProgramsStatuses != null || programId != null) {
    return (userProgramsStatuses[programId.toString()]["isViewable"] &&
        isAvailable(userProgramsStatuses[programId.toString()]["availableTill"]
            .toString()));
  } else
    return false;
}
