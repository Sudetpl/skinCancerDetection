import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow/registration_screen.dart';

import 'homepage.dart';
import 'login_screen.dart';

class AppRoute {
  Route onGeneralRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;
      case RegistrationScreen.route:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
        break;
      case Home.route:
        return MaterialPageRoute(builder: (_) => Home());
        break;
      default:
        return null;
    }
  }
}
