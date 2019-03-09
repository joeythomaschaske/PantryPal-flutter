import 'package:flutter/material.dart';
import '../Home/Home.dart';
import '../Register/Register.dart';
import '../Init/Init.dart';
import '../../contstants.dart' as Constants;

// good example
//https://github.com/flutter/flutter/issues/19194
//make an auth route that returns a loading screen
//if authenticated navigate to home
//otherwise navigate to login
class Root extends StatefulWidget {
  @override
  State createState() => RootState();
}

class RootState extends State<Root> {
  static Map<String, Widget> routeTable = {
    Constants.INIT: Init(),
    Constants.REGISTER : Register(),
    Constants.HOME: Home()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          Constants.INIT : (context) => Init(),
          Constants.REGISTER : (context) => Register(),
          Constants.HOME : (context) => Home()
        },
        // onGenerateRoute: (routeSettings) {
        //   AuthContainerState data = AuthContainer.of(context);
        //   WidgetBuilder screen = (context) => Container();
        //   if (routeSettings.name == Constants.INIT) {
        //     screen = (context) => Init();
        //   } else if (data.isAuthenticated()) {
        //     screen = (context) => SafeArea(
        //         child: Material(
        //             type: MaterialType.transparency,
        //             child: routeTable[routeSettings.name]));
        //   } else {
        //     screen = (conext) => SafeArea(
        //         child: Material(
        //             type: MaterialType.transparency, child: Register()));
        //   }
        //   return new MaterialPageRoute(
        //     builder: screen,
        //     settings: routeSettings,
        //   );
        // }
      );
  }
}
