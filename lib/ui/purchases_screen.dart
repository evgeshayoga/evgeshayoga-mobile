import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/program_screen.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PurchasesScreen extends StatefulWidget {
  User user;

  PurchasesScreen(this.user, {Key key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbProgramsReference;

  @override
  void initState() {
    super.initState();
    dbProgramsReference = database.reference().child("marathons");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> purchases = [];
    widget.user.getPurchases().programs.forEach((idx, item) {
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
        backgroundColor: Colors.white,
        title: Text(
          "Покупки",
          style: Style.headerTextStyle,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
//            Text(
//              "Purchases",
//              textAlign: TextAlign.center,
//              style: Style.header2TextStyle,
//            ),
            Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Программа",
                            textAlign: TextAlign.center,
                            style: Style.header2TextStyle,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Доступ до",
                            textAlign: TextAlign.center,
                            style: Style.header2TextStyle,
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
              var router =
                  new MaterialPageRoute(builder: (BuildContext context) {
                return ProgramScreen(purchaseTitle, purchaseId);
              });
              Navigator.of(context).push(router);
            },
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              dateFormatted(availableTill),
              style: Style.regularTextStyle,
            )),
      ],
    );
  }
}
