import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/login_screen.dart';
import 'package:evgeshayoga/ui/video_content/programs_screen.dart';
import 'package:evgeshayoga/utils/animator.dart';
import 'package:evgeshayoga/utils/start_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FirebaseInitializer());
}

class FirebaseInitializer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp().then((snapshot) {
        if (kDebugMode) {
          FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(false);
        }
        return snapshot;
      }),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return App();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProviderModel(new FirebaseAuthAdapter())),
        ChangeNotifierProvider(create: (context) => InfoProviderModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Style.pinkMain,
          textTheme: TextTheme(
            headline5: Style.titleTextStyle,
            headline6: Style.headerTextStyle,
            bodyText2: Style.regularTextStyle,
            bodyText1: Style.regularTextStyle,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: "Йога с Женей",
        initialRoute: '/',
        home: StartScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeAnimator(),
          '/login': (BuildContext context) => Login(),
          '/programs': (BuildContext context) => Programs(),
        },
      ),
    );
  }
}