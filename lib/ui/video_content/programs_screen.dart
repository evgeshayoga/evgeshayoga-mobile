import 'package:cached_network_image/cached_network_image.dart';
import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/ui/video_content/components/drawer_content_screen.dart';
import 'package:evgeshayoga/ui/video_content/program_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/check_is_landscape.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/getUserAccessStatus.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Programs extends StatefulWidget {
  final String userUid;

  Programs({Key? key, required this.userUid}) : super(key: key);

  @override
  _ProgramsState createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  final DatabaseReference dbProgramsReference =
      FirebaseDatabase.instance.ref("marathons");

  Map<String, dynamic> userProgramsStatuses = new Map();
  bool _isInAsyncCall = false;
  bool noActivePrograms = false;

  @override
  void initState() {
    super.initState();
    getUserProgramsStatuses(widget.userUid).then((statuses) {
      setState(() {
        userProgramsStatuses = statuses;
        _isInAsyncCall = true;
      });
    });

    dbProgramsReference.once().then((event) {
      _isInAsyncCall = false;
      List<dynamic> activePrograms = [];
      var value = event.snapshot.value as List<Object?>;
      value.forEach((program) {
        if (program != null) {
          var mappedProgram = new Map<String, dynamic>.from(program as dynamic);
          if (mappedProgram["isActive"] == true) {
            activePrograms.add(program);
          }
        }
      });
      setState(() {
        noActivePrograms = activePrograms.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = checkIsLandscape(context);

    return Scaffold(
      drawer: drawerProgramScreen(isLandscape),
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
          "Программы",
          style: Style.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Style.pinkMain,
      ),
      body: noActivePrograms
          ? Center(
              child: Text(
                'Нет активных программ',
                style: Style.regularTextStyle,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: FirebaseAnimatedList(
                    defaultChild: Container(
                        height: 300, child: progressHUD(_isInAsyncCall)),
                    query: dbProgramsReference,
                    sort: (sa, sb) {
                      return (sb.value as Map)["id"] - (sa.value as Map)["id"];
                    },
                    itemBuilder: (_, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      var program = Program.fromSnapshot(snapshot);
                      String key = program.id.toString();
                      var hasStatus = userProgramsStatuses.containsKey(key);

                      if (!program.isActive || !hasStatus) {
                        return _inactiveProgram();
                      }
                      String date = userProgramsStatuses[key]["availableTill"].toString();
                      if (isViewable(userProgramsStatuses, program.id)) {
                        return _availableProgram(
                            date, snapshot.value, isLandscape);
                      }
                      return _notAvailableProgram(
                          snapshot.value, context, isLandscape);
                    },
                  ),
                )
              ],
            ),
    );
  }

  Widget _inactiveProgram() {
    return Container();
  }

  Widget _notAvailableProgram(program, BuildContext context, isLandscape) {
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
              child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: CachedNetworkImageProvider(
                      "https://evgeshayoga.com" + thumbnailUrl))),
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
          TextButton(
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
        child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(
                "https://evgeshayoga.com" + program["thumbnailUrl"])),
      ),
    );

    Text title = Text(
      program["title"],
      textAlign: TextAlign.center,
      style: Style.headerTextStyle,
    );

    return Container(
      child: Card(
        child: GestureDetector(
          onTap: () {
            var router = new MaterialPageRoute(builder: (BuildContext context) {
              return ProgramScreen(program["title"], program["id"]);
            });
            var nav = Navigator.of(context);
            nav.push(router);
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

bool isViewable(Map? userProgramsStatuses, int programId) {
  if (userProgramsStatuses != null && programId > 0) {
    String key = programId.toString();
    if (userProgramsStatuses.containsKey(key)) {
      return (userProgramsStatuses[key]["isViewable"] &&
          isAvailable(userProgramsStatuses[key]["availableTill"].toString()));
    }
  }
  return false;
}
