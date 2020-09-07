import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      var currentUser = fbauth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, "/home");
        return;
      }
      Future.delayed(Duration(milliseconds: 100)).then((_) {
        Provider.of<InfoProviderModel>(context, listen: false).initialize();
        return Provider.of<UserProviderModel>(context, listen: false)
            .login(currentUser.uid);
      }).then((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return YogaOnlineScreen(userUid: currentUser.uid);
        }));
      }).catchError((Object error) {
        Navigator.pushReplacementNamed(context, "/home");
        Provider.of<UserProviderModel>(context, listen: false).logout();
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        child: Text("Error"),
      );
    }
    if (!_initialized) {
      Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container();
  }
}

//class LandingPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<FirebaseUser>(
//      stream: FirebaseAuth.instance.onAuthStateChanged,
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.active) {
//          FirebaseUser user = snapshot.data;
//          if (user == null) {
//            return HomeAnimator();
//          }
//          return Programs();
//        } else {
//          return Scaffold(
//            body: Center(
//              child: CircularProgressIndicator(),
//            ),
//          );
//        }
//      },
//    );
//  }
//}
