import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
}
