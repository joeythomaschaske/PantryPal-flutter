import 'package:flutter/material.dart';
import '../../sharedServices/Auth.dart';
import '../Home/Home.dart';
import '../Register/Register.dart';
import '../../contstants.dart' as Constants;

class Root extends StatelessWidget {
  static Map<String, Widget> routeTable = {
    Constants.HOME :  Home()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (routeSettings) {
        AuthContainerState data = AuthContainer.of(context);
        WidgetBuilder screen;
        if (data.isAuthenticated()) {
          screen = (context) => SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: routeTable[routeSettings.name]
            )
          );
        } else {
          screen = (conext) => SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: Register()
            )
          );
        }
        return new MaterialPageRoute(
          builder: screen,
          settings: routeSettings,
        );
      }
    );
  }
}