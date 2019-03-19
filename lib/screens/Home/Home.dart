import 'package:flutter/material.dart';
import '../../contstants.dart' as Constants;
import '../../sharedServices/Auth.dart';

class Home extends StatelessWidget {
  Home() : super();

  Future<void> logout(BuildContext context) async  {
    AuthContainerState data = AuthContainer.of(context);
    await data.logout(context);
    Navigator.of(context).pushNamedAndRemoveUntil(Constants.REGISTER, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    AuthContainerState a = AuthContainer.of(context);
    List<Widget> children;
    if (a.user != null) {
      children = <Widget>[
        Text(a.user.firstName),
        Text(a.user.lastName),
        Text(a.user.email)
      ];
    } else {
      children = <Widget>[Container()];
    }
    return (Scaffold(
        body: Center(
            child: ListView(
          children: children,
        )),
        floatingActionButton: FloatingActionButton(onPressed: () => logout(context))));
  }
}
