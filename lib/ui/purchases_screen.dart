import 'dart:convert';

import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class PurchasesScreen extends StatefulWidget {
  User user;
  final String userUid;

  PurchasesScreen(this.user, this.userUid, {Key key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbUserPurchasesReference;
  List<Widget> purchases = [];

  @override
  void initState() {
    super.initState();
//    purchases = buildPurchases(widget.user.getPurchases().programs);

    dbUserPurchasesReference = database
        .reference()
        .child("users")
        .child(widget.userUid)
        .child("purchases");
    dbUserPurchasesReference.onValue.listen(_onPurchasesUpdated);
  }

  List<Widget> buildPurchases(Map<int, dynamic> programs) {
    List<Widget> purchases = [];
    programs.forEach((idx, item) {
      purchases.add(Padding(
        padding: EdgeInsets.all(8),
      ));
      purchases.add(
          purchasesListItem(item["title"], item["id"], item["availableTill"]));
      purchases.add(
        Divider(
          height: 7,
          color: Style.pinkDark,
        ),
      );
    });
    return purchases;
  }

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
        automaticallyImplyLeading: false,
        backgroundColor: Style.pinkMain,
        title: Text(
          "Покупки",
          style: Style.titleTextStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed:(){
              http.post(
                "https://evgeshayoga.com/api/sync",
                body: json.encode({"id": widget.user.userId}),
                headers: {'Content-Type': 'application/json'},
              );
            } ,
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Программа",
                            textAlign: TextAlign.center,
                            style: Style.headerTextStyle,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Доступ до",
                            textAlign: TextAlign.center,
                            style: Style.headerTextStyle,
                          ))
                    ],
                  ),
                  Column(
                    children: purchases,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget purchasesListItem(purchaseTitle, purchaseId, availableTill) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: FlatButton(
            splashColor: Style.pinkLight,
            child: Text(
              purchaseTitle,
              textAlign: TextAlign.center,
              style: Style.regularTextStyle,
            ),
            onPressed: () {
              if (isAvailable(availableTill)) {
                var router = MaterialPageRoute(builder: (BuildContext context) {
                  return ProgramScreen(purchaseTitle, purchaseId);
                });
                Navigator.of(context).push(router);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      purchaseTitle,
                      textAlign: TextAlign.center,
                      style: Style.headerTextStyle,
                    ),
                    content: Text(
                      "Программа не доступна",
                      textAlign: TextAlign.center,
                      style: Style.regularTextStyle,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              dateFormatted(availableTill),
              textAlign: TextAlign.center,
              style: Style.regularTextStyle,
            )),
      ],
    );
  }

  void _onPurchasesUpdated(Event event) {
    var up = UserPurchases(event.snapshot.value);
    setState(() {
      purchases = buildPurchases(up.programs);
    });
  }
}
