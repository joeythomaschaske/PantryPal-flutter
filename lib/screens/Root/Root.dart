import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Home/Home.dart';
import '../Register/Register.dart';
import '../Account/Account.dart';
import '../AddIngredient/AddIngredient.dart';
import '../Ingredients//Ingredients.dart';
import '../../contstants.dart' as Constants;
import '../../utilities/JWT.dart';

class Root extends StatefulWidget {
  final bool authenticated;

  Root({this.authenticated});
  @override
  State createState() => RootState();
}

class RootState extends State<Root> {
  static Map<String, Widget> routeTable = {
    Constants.REGISTER: Register(),
    Constants.HOME: Home(),
    Constants.ACCOUNT: Account(),
    Constants.ADDINGREDIENT: AddIngredient(),
    Constants.INGREDIENTS : Ingredients()
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (routeSettings) {
      Map<String, dynamic> sessionTokens =
          routeSettings.arguments != null ? routeSettings.arguments : null;
      WidgetBuilder screen;
      if ((widget.authenticated && sessionTokens == null) || ( sessionTokens != null && (JWT.isActive(sessionTokens['identityToken']) || JWT.refreshTokenActive(sessionTokens['refreshTokenExpiration'])))) {
        screen = (context) => SafeArea(
            bottom: false,
            child: Material(
                type: MaterialType.transparency,
                child: routeTable[routeSettings.name]));
      } else {
        screen = (conext) => SafeArea(
            bottom: false,
            child:
                Material(type: MaterialType.transparency, child: Register()));
      }
      return new MaterialPageRoute(
        builder: screen,
        settings: routeSettings,
      );
    });
  }
}