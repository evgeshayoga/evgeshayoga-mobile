import 'package:evgeshayoga/ui/video_content/content_screen.dart' as prefix0;
import 'package:evgeshayoga/ui/video_content/programs_screen.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String userUid;

  SubscriptionScreen(this.userUid, {Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Map<String, dynamic> userSubscriptionStatus = {};
  bool isSubscribed = false;
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isInAsyncCall = true;
    });
//    purchases = buildPurchases(widget.user.getPurchases().programs);

    getUserSubscriptionStatus(widget.userUid).then((status) {
      setState(() {
        userSubscriptionStatus = status;
        isSubscribed = userSubscriptionStatus['isSubscriptionActive'];
        _isInAsyncCall = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userSubscriptionStatus == null) {
      return progressHUD(_isInAsyncCall);
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
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.update),
//            onPressed: () {
//              getUserProgramsStatuses(widget.userUid).then((status) {
//                setState(() {
//                  userSubscriptionStatus = status;
//                });
//              });
//            },
//          )
//        ],
      ),
      body: Center(
        child: _isInAsyncCall ? progressHUD(_isInAsyncCall) : Container(
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
              return YogaOnlineScreen(userUid: widget.userUid);
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
