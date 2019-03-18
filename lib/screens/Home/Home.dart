import 'package:flutter/material.dart';
import '../../contstants.dart' as Constants;
import '../../sharedServices/Auth.dart';

class Home extends StatelessWidget {
  Home() : super();

  @override
  Widget build(BuildContext context) {
    AuthContainerState a = AuthContainer.of(context);
    List<Widget> children;
    if (a.user != null) {
      children = <Widget>[
              Text(
                a.user.firstName
              ),
              Text(
                a.user.lastName
              ),
              Text(
                a.user.email
              )
            ];
    } else {
      children = <Widget>[Container()];
    }
    return (
      Scaffold(
        body: Center(
          child: ListView(
            children:children ,
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            a.logout(context)
            .then((res) {
              Navigator.of(context).pushNamedAndRemoveUntil(Constants.REGISTER, (Route<dynamic> route) => false);
            });
          }
        )
      )
    );
  }
}