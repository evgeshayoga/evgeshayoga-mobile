import 'package:flutter/material.dart';

class Style {
  static final pinkMain = const Color.fromRGBO(242, 206, 210, 1);
  static final pinkDark = const Color.fromRGBO(175, 111, 120, 1);
  static final pinkLight = const Color.fromRGBO(249, 231, 231, 1);
  static final blueGrey = const Color.fromRGBO(94, 101, 111, 1);

  static final regularTextStyle = const TextStyle(
    fontFamily: "Nunito",
    letterSpacing: -0.3,
    fontWeight: FontWeight.normal,
    fontSize: 18,
    color: Color.fromRGBO(94, 101, 111, 1),
  );
  static final headerTextStyle = const TextStyle(
    fontFamily: "GarageGothic",
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: Color.fromRGBO(94, 101, 111, 1),
  );
  static final header2TextStyle = const TextStyle(
    fontFamily: "Nunito",
    height: 1.5,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Color.fromRGBO(94, 101, 111, 1),
  );
}
