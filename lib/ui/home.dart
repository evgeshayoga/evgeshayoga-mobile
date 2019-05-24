import 'package:evgeshayoga/ui/registration_page.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const int tabletBreakpoint = 600;
  Widget _buildHomeLandscapeLayout(){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: Opacity(
            opacity: 1,
            child: Image.asset('assets/images/photo_3_portrait.jpg',
                fit: BoxFit.cover),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
//                  flex: 1,
//                    alignment: Alignment.bottomLeft,
//                    margin: const EdgeInsets.fromLTRB(60, 0, 0, 30),
                  child: new MaterialButton(
                      minWidth: 120,
                      onPressed: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Login();
                            });
                        Navigator.of(context).push(router);
                      },
                      color: Color.fromRGBO(242, 206, 210, 1),
                      child: new Text(
                        "Вход",
                        style: TextStyle(
                            color: Color.fromRGBO(94, 101, 111, 1),
                            fontSize: 16.9),
                      ))),
              new Container(
//                  flex: 1,
//                  alignment: Alignment.bottomLeft,
//                  margin: const EdgeInsets.fromLTRB(100, 0, 0, 30),
                child: new MaterialButton(
                    minWidth: 120,
                    color: Color.fromRGBO(242, 206, 210, 1),
                    onPressed: () async {
                      var url = 'https://evgeshayoga.com/register';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: new Text(
                      "Регистрация",
                      style: TextStyle(
                          color: Color.fromRGBO(94, 101, 111, 1),
                          fontSize: 16.9),
                    )),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
          child: Column(
            children: <Widget>[
              Text(
                'ЙОГА С ЖЕНЕЙ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "GarageGothic",
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
//                      letterSpacing: 0,
                  color: Color.fromRGBO(94, 101, 111, 1),
                ),
              ),
              Text(
                'СВОБОДА В ДВИЖЕНИИ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "GarageGothic",
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -1,
                  color: Color.fromRGBO(94, 101, 111, 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomePortraitLayout(){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: Opacity(
            opacity: 1,
            child: Image.asset('assets/images/photo_3_portrait.jpg',
                fit: BoxFit.cover),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
//                  flex: 1,
//                    alignment: Alignment.bottomLeft,
//                    margin: const EdgeInsets.fromLTRB(60, 0, 0, 30),
                  child: new MaterialButton(
                      minWidth: 120,
                      onPressed: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Login();
                            });
                        Navigator.of(context).push(router);
                      },
                      color: Color.fromRGBO(242, 206, 210, 1),
                      child: new Text(
                        "Вход",
                        style: TextStyle(
                            color: Color.fromRGBO(94, 101, 111, 1),
                            fontSize: 16.9),
                      ))),
              new Container(
//                  flex: 1,
//                  alignment: Alignment.bottomLeft,
//                  margin: const EdgeInsets.fromLTRB(100, 0, 0, 30),
                child: new MaterialButton(
                    minWidth: 120,
                    color: Color.fromRGBO(242, 206, 210, 1),
                    onPressed: () async {
                      var url = 'https://evgeshayoga.com/register';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: new Text(
                      "Регистрация",
                      style: TextStyle(
                          color: Color.fromRGBO(94, 101, 111, 1),
                          fontSize: 16.9),
                    )),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
          child: Column(
            children: <Widget>[
              Text(
                'ЙОГА С ЖЕНЕЙ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "GarageGothic",
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
//                      letterSpacing: 0,
                  color: Color.fromRGBO(94, 101, 111, 1),
                ),
              ),
              Text(
                'СВОБОДА В ДВИЖЕНИИ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "GarageGothic",
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -1,
                  color: Color.fromRGBO(94, 101, 111, 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    Widget homePageContent;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait && shortestSide < tabletBreakpoint) {
      homePageContent = _buildHomePortraitLayout();
    } else {
      homePageContent = _buildHomeLandscapeLayout();
    }

    return homePageContent;
  }
}