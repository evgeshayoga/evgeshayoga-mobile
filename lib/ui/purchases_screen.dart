import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/user.dart';
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
      purchases.add(Text(item["title"]));
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
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Text(
              "Purchases",
              textAlign: TextAlign.center,
              style: Style.header2TextStyle,
            ),
            Center(
              child: Column(
                children: purchases,
              ),
            )
          ],
        ),
      ),
    );
  }
}
