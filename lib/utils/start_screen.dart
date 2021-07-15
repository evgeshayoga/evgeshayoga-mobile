import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  initState() {
    super.initState();
    Provider.of<InfoProviderModel>(context, listen: false).initialize();
    Future.value(FirebaseAuth.instance.currentUser).then((currentUser) {
      if (currentUser == null) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Future.delayed(Duration(milliseconds: 100)).then((_) {
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
      }
    });
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
