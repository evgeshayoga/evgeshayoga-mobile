import 'package:evgeshayoga/models/week.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WeekScreen extends StatelessWidget {
  Week week;
  WeekScreen(this.week);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Style.blueGrey,
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Style.pinkMain,
        title: Text(week.title, style: Style.titleTextStyle,),
      ),
      body: ListView(
        children: <Widget>[
          HtmlWidget(week.content)
        ],
      ),
    );
  }

}
