import 'package:evgeshayoga/ui/programs/content_screen.dart' as prefix0;
import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:evgeshayoga/ui/programs/yoga_online.dart';
import 'package:evgeshayoga/utils/style.dart';

class SubscriptionScreen extends StatefulWidget {
  final String userUid;

  SubscriptionScreen(this.userUid, {Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Map<String, dynamic> userSubscriptionStatus = {};
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
//    purchases = buildPurchases(widget.user.getPurchases().programs);

    getUserSubscriptionStatus(widget.userUid).then((status) {
      setState(() {
        userSubscriptionStatus = status;
        isSubscribed = userSubscriptionStatus['isSubscriptionActive'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userSubscriptionStatus == null) {
      return progressHUD();
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Style.blueGrey,
            );
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Style.pinkMain,
        title: Text(
          "Подписка Yoga Online",
          style: Style.titleTextStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              getUserProgramsStatuses(widget.userUid).then((status) {
                setState(() {
                  userSubscriptionStatus = status;
                });
              });
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: isSubscribed
              ? subscriptionDetails(userSubscriptionStatus)
              : Text("Вы не подписаны на Yoga Online"),
        ),
      ),
    );
  }

  Widget subscriptionDetails(subscription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Вы подписаны на Yoga Online"),
        Text("Подписка активна до " + dateFormatted(subscription['expiryDate'])),
        Container(
          padding: EdgeInsets.all(20),
        ),
        RaisedButton(
          onPressed: (){
            var router =
            new MaterialPageRoute(builder: (BuildContext context) {
              return prefix0.ContentScreen(userUid: widget.userUid);
            });
            Navigator.of(context).push(router);
          },
          color: Style.pinkMain,
          child: Text(
            "Перейти к занятиям",
            style: Style.regularTextStyle,
          ),
        ),
      ],
    );
  }
}
