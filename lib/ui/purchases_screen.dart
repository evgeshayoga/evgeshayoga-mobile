import 'package:evgeshayoga/ui/programs/program_screen.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/utils/check_is_available.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PurchasesScreen extends StatefulWidget {
  final String userUid;

  PurchasesScreen(this.userUid, {Key key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  Map<String, dynamic> userProgramsStatuses = {};

  @override
  void initState() {
    super.initState();
//    purchases = buildPurchases(widget.user.getPurchases().programs);

    getUserProgramsStatuses(widget.userUid).then((statuses) {
      setState(() {
        userProgramsStatuses = statuses;
      });
    });
  }

  List<Widget> buildPurchases(programs) {
    List<Widget> purchases = [];

    if (widget.userUid == 'xMcQSM0MRjVtlAEns8bxyddVWlI2'
        || widget.userUid == "SI5ecDdX3qfH6igB4ileyL9sCiD3" //ura's id
    ) {
      final purchasedPrograms = Map.from(programs);
      purchasedPrograms.forEach((k, v) {
        if (isAvailable(v["availableTill"])) {
          purchases.add(Padding(
            padding: EdgeInsets.all(8),
          ));
          purchases.add(purchasesListItem(v));
          purchases.add(
            Divider(
              height: 7,
              color: Style.pinkDark,
            ),
          );
        }
      });
    } else {
      final purchasedPrograms = Map.from(programs)
        ..removeWhere((k, v) => v["isPurchased"] == false);

      purchasedPrograms.forEach((k, v) {
        purchases.add(Padding(
          padding: EdgeInsets.all(8),
        ));
        purchases.add(purchasesListItem(v));
        purchases.add(
          Divider(
            height: 7,
            color: Style.pinkDark,
          ),
        );
      });
    }
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
            onPressed: () {
              getUserProgramsStatuses(widget.userUid).then((statuses) {
                setState(() {
                  userProgramsStatuses = statuses;
                });
              });
            },
          )
        ],
      ),
      body: Center(
        child: userProgramsStatuses == null
            ? ModalProgressHUD(
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Style.pinkMain),
                ),
                inAsyncCall: true,
                child: Text(
                  "Загружается...",
                  textAlign: TextAlign.center,
                ),
              )
            : ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Row(
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
                          children: buildPurchases(userProgramsStatuses),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget purchasesListItem(purchase) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: FlatButton(
            splashColor: Style.pinkLight,
            child: Text(
              purchase["title"],
              textAlign: TextAlign.center,
              style: Style.regularTextStyle,
            ),
            onPressed: () {
              if (isAvailable(purchase["availableTill"])) {
                var router = MaterialPageRoute(builder: (BuildContext context) {
                  return ProgramScreen(purchase["title"], purchase["id"]);
                });
                Navigator.of(context).push(router);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      purchase["title"],
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
            dateFormatted(purchase["availableTill"]),
            textAlign: TextAlign.center,
            style: Style.regularTextStyle,
          ),
        ),
      ],
    );
  }
}
