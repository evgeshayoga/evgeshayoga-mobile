import 'package:evgeshayoga/models/user.dart';
import 'package:flutter/material.dart';

class PurchasesScreen extends StatelessWidget {
  User user;
  @override
  PurchasesScreen(this.user, {Key key}) : super(key: key);

  Widget build(BuildContext context) {
    List <Widget> purchases = [];
    user.getPurchases().programs.forEach((idx, item){
      purchases.add(Text(item["title"]));
    });


    return Scaffold(
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Purchases"),
            Column(
              children: purchases
            )
          ],
        ),
      ),
    );
  }
}
