import 'package:evgeshayoga/ui/programs/content_screen.dart';
//import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  initState() {
    FirebaseAuth.instance.currentUser().then((currentUser) {
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ContentScreen(userUid: currentUser.uid);
        }));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
