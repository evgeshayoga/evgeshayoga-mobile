import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/login_screen.dart';
import 'package:evgeshayoga/ui/video_content/programs_screen.dart';
import 'package:evgeshayoga/utils/animator.dart';
import 'package:evgeshayoga/utils/get_start_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';

void main() {
  Crashlytics.instance.enableInDevMode =
      true; // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProviderModel()),
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
  ));
}
