import 'package:evgeshayoga/ui/animation.dart';
import 'package:evgeshayoga/ui/marathons.dart';
import 'package:evgeshayoga/ui/registration_page.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meta/meta.dart';

class Home extends StatelessWidget {
  Home({@required AnimationController controller})
      : animation = HomeAnimation(controller);

  final HomeAnimation animation;
  static const int tabletBreakpoint = 600;

  Widget _buildHomeLayout(BuildContext context, bool isLandscape) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Opacity(
                opacity: animation.bgdropOpacity.value,
                child: Image.asset('assets/images/photo_3_portrait.jpg',
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: isLandscape
                  ? EdgeInsets.fromLTRB(0, 0, 0, 13)
                  : EdgeInsets.fromLTRB(0, 0, 0, 30),
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
                          fontSize: 16.9,
                        ),
                      ),
                    ),
                  ),
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
                      ),
                    ),
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
                      fontSize: 30 * animation.titleSize.value,
                      fontWeight: FontWeight.w800,
//                      letterSpacing: 0,
                      color: Color.fromRGBO(94, 101, 111, 1)
                          .withOpacity(animation.titleOpacity.value),
                    ),
                  ),
                  Text(
                    'СВОБОДА В ДВИЖЕНИИ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "GarageGothic",
                      fontSize: 20 * animation.titleSize.value,
                      fontWeight: FontWeight.w200,
                      letterSpacing: -1,
                      color: Color.fromRGBO(94, 101, 111, 0.6)
                          .withOpacity(animation.titleOpacity.value),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: new MaterialButton(
                minWidth: 120,
                onPressed: () {
                  var router = new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Marathons();
                      });
                  Navigator.of(context).push(router);
                },
                color: Colors.white,
                child: new Text(
                  "Перейти к рограммам",
                  style: TextStyle(
                    color: Color.fromRGBO(94, 101, 111, 1),
                    fontSize: 16.9,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
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

    return AnimatedBuilder(
      animation: animation.controller,
      builder: (BuildContext context, Widget child) =>
          _buildHomeLayout(context, isLandscape),
    );
  }
}
