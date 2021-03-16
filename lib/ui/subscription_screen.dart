import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/getUserAccessStatus.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

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
    var expiryDate = subscription['expiryDate'];
    DateTime parsedExpiryDate = DateTime.parse(expiryDate);
    Widget dateWidget = parsedExpiryDate.difference(DateTime.now()).inDays > 365
        ? Text("Подписка активна")
        : Text("Подписка активна до " + dateFormatted(expiryDate));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Вы подписаны на Yoga Online"),
        dateWidget,
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
