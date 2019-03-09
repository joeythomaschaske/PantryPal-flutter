import 'package:flutter/material.dart';
import '../../sharedServices/Auth.dart';
import '../../contstants.dart' as Constants;

class Init extends StatefulWidget {
  @override
  InitState createState() => InitState();
}

class InitState extends State<Init> {

  @override
  Widget build(BuildContext context) {
    AuthContainerState data = AuthContainer.of(context);
    data.loadAuthFromStorage()
    .then((authenticated) {
      if (authenticated) {
        Navigator.of(context).pushNamedAndRemoveUntil(Constants.HOME, (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Constants.HOME, (Route<dynamic> route) => false);
      }
    });
    return Container();
  }
}