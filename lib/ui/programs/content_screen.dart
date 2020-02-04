import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/components/drawer_content_screen.dart';
import 'package:evgeshayoga/ui/programs/filter_screen.dart';
import 'package:evgeshayoga/ui/programs/yoga_online_screen.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
  String _value;

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
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;
    var isLandscape = true;
    if (orientation == Orientation.portrait &&
        shortestSide < tabletBreakpoint) {
      isLandscape = false;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: drawerProgramScreen(user, context, widget.userUid, isLandscape),
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Container(
                  height: 50,
                  child: Center(child: Text("Преподаватель")),
                ),
                Container(
                  height: 50,
                  child: Center(child: Text("Тип")),
                ),
                DropdownButton(
                  items: [
                    DropdownMenuItem<String>(
                      value: "1",
                      child: Text(
                        "First",
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "2",
                      child: Text(
                        "Second",
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  value: _value,
                  hint: Text(
                    "Тип",
                  ),
                )
              ],
            ),
          ),
        ),
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
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Image.asset(
              'assets/images/logo_white.png',
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
              height: 30,
            ),
            bottom: TabBar(
              indicatorColor: Style.pinkDark,
              unselectedLabelColor: Colors.white,
              labelColor: Style.blueGrey,
              tabs: [
                Tab(
                  text: "Йога-онлайн",
                ),
                Tab(
                  text: "Программы",
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Style.pinkMain,
//            actions: [
//              Builder(
//                  builder: (context) => IconButton(
//                        icon: Icon(
//                          AntDesign.filter,
//                          size: 26.0,
//                          color: Style.blueGrey,
//                        ),
//                        onPressed: () {
//                          var router =
//                          new MaterialPageRoute(builder: (BuildContext context) {
//                            return FilterScreen();
//                          });
//                          Navigator.of(context).push(router);
//                        },
//                      ))
//            ]
//          <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: GestureDetector(
//                onTap: () {},
//                child: Icon(
//                  Icons.search,
//                  size: 26.0,
//                  color: Style.blueGrey,
//                ),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: GestureDetector(
//                onTap: () => Scaffold.of(context).openEndDrawer(),
//                child: Icon(
//                  AntDesign.filter,
//                  size: 26.0,
//                  color: Style.blueGrey,
//                ),
//              ),
//            )
//          ],
            ),
        body: WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: Stack(
            children: <Widget>[
              TabBarView(
                children: <Widget>[
                  YogaOnlineScreen(userUid: widget.userUid),
                  Programs(
                    userUid: widget.userUid,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Filter"),
        ],
      ),
    );
  }
}

Widget filterDrawer(context) {
  return Drawer(
    child: SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Container(
            height: 50,
            child: Center(child: Text("Преподаватель")),
          ),
          Container(
            height: 50,
            child: Center(child: Text("Тип")),
          ),

        ],
      ),
    ),
  );
}

