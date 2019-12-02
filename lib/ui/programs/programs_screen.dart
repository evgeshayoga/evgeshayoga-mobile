import 'dart:convert';
import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Programs extends StatefulWidget {
  final String userUid;

  Programs({Key key, this.userUid}) : super(key: key);

  @override
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
            query: dbProgramsReference,
            sort: (sa, sb) {
              return sb.value["id"] - sa.value["id"];
            },
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
                int index) {
              if (snapshot == null || userProgramsStatuses == null) {
                return Container(
                  height: 300,
                    child: progressHUD());
              }
              var program = Program.fromSnapshot(snapshot);
              if (widget.userUid == 'xMcQSM0MRjVtlAEns8bxyddVWlI2'
                  || widget.userUid == "SI5ecDdX3qfH6igB4ileyL9sCiD3"
              ) {
                String date = userProgramsStatuses[program.id.toString()]
                ["availableTill"]
                    .toString();
                if (isAvailable(date)) {
                  return _availableProgram(date, snapshot.value, isLandscape);
                } else return Container();
              }
              else {
               if (!program.isActive) {
              return _inactiveProgram();
              }

              if (isViewable(userProgramsStatuses, program.id)) {
              String date = userProgramsStatuses[program.id.toString()]
              ["availableTill"]
                  .toString();
              return _availableProgram(date, snapshot.value, isLandscape);
              }
              return _notAvailableProgram(
              programs, snapshot.value, context, isLandscape);
              }
            },
          ),
        )
      ],
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
