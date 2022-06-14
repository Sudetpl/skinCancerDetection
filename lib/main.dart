import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tensorflow/login_screen.dart';
import 'package:tensorflow/nav_bar_screen.dart';
import 'package:tensorflow/route.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final AppRoute _appRoute = AppRoute();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Skin Cancer',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Colors.amber[900],
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: Colors.amber[900]),
              backwardsCompatibility: false),
          iconTheme: IconThemeData(
            color: Colors.amber[900],
          ),
          textTheme: TextTheme(
            headline3: TextStyle(
              color: Colors.white,
            ),
            headline4: TextStyle(
              color: Colors.white,
            ),
            headline5: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
          buttonColor: Colors.amber[900],
          backgroundColor: Colors.amber[900],
        ),
        onGenerateRoute: _appRoute.onGeneralRoute,
        builder: EasyLoading.init(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return NavBarScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
