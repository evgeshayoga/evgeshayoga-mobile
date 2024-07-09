import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/login_screen.dart';
import 'package:evgeshayoga/utils/animator.dart';
import 'package:evgeshayoga/utils/start_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  runApp(App());
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
          colorScheme: ColorScheme.light(primary: Style.pinkMain),
          splashColor: Style.pinkMain.withOpacity(.5),
          highlightColor: Style.pinkMain.withOpacity(.5),
          // elevatedButtonTheme: ElevatedButtonThemeData(
          //  style: ElevatedButton.styleFrom(primary: Style.pinkMain)
          // ),
          // outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(primary: Style.pinkDark)),
          // textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Style.pinkDark)),
          textTheme: TextTheme(
            headlineSmall: Style.titleTextStyle,
            titleLarge: Style.headerTextStyle,
            bodyMedium: Style.regularTextStyle,
            bodyLarge: Style.regularTextStyle,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: "Йога с Женей",
        initialRoute: '/',
        home: StartScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeAnimator(),
          '/login': (BuildContext context) => Login(),
        },
      ),
    );
  }
}