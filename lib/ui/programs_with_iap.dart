import 'dart:async';
import 'dart:convert';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/components/drawer_content_screen.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:io';

class IAPScreen extends StatefulWidget {
  final String userUid;

  IAPScreen({Key key, this.userUid}) : super(key: key);

  @override
  _IAPScreenState createState() => _IAPScreenState();
}

class _IAPScreenState extends State<IAPScreen> {
  static const int tabletBreakpoint = 600;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbUsersReference;
  DatabaseReference dbProgramsReference;
  User user;
  Map<String, dynamic> userProgramsStatuses;
  final String productId = 'program1';

  bool available = true;
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      await _getPastPurchases();
    }
    // ... omitted
    // Listen to new purchases
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
//      _verifyPurchase();
        }));
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(([productId]));
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    setState(() {
      _products = response.productDetails;
      debugPrint("PRODUCTS " + _products.length.toString());
    });
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.completePurchase(purchase);
      }
    }
    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  PurchaseDetails _hasPurchased(String productId) {
    return _purchases.firstWhere((purchase) => purchase.productID == productId,
        orElse: () => null);
  }

  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(productId);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {}
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    debugPrint("BUY " + prod.id);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Image.asset(
            'assets/images/logo_white.png',
//            'assets/images/logo.png',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
            height: 35,
          ),
          bottom: TabBar(
            indicatorColor: Style.pinkDark,
            unselectedLabelColor: Colors.white,
            labelColor: Style.blueGrey,
            tabs: [
              Tab(
                text: "IAP",
//                icon: new Icon(Icons.audiotrack),
              ),
//              Tab(
//                text: "Йога-онлайн",
////                icon: new Icon(Icons.beach_access),
//              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(242, 206, 210, 1),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: TabBarView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    _hasPurchased(productId) != null
                        ? purchasedProgram()
                        : notPurchasedProgram(productId)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget purchasedProgram() {
    return Container(
      child: Card(
        child: GestureDetector(
          onTap: () {
            debugPrint("Open program");
          },
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text("Program 1"),
                  subtitle: Text("Purchased Program")),
            ],
          ),
        ),
      ),
    );
  }

  Widget notPurchasedProgram(prod) {
    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Program 1"),
              subtitle: Text("Purchasable Program"),
            ),
            RaisedButton(
              child: Text("Buy"),
              onPressed: () {
//                _buyProduct(_products[0]);
              debugPrint("PRODUCTS " + _products.length.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}
