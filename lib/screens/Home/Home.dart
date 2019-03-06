import 'package:flutter/material.dart';
import '../../contstants.dart' as Constants;
import '../../sharedServices/Auth.dart';

class Home extends StatelessWidget {
  Home() : super();

  @override
  Widget build(BuildContext context) {
    AuthContainerState a = AuthContainer.of(context);
    return (
      Scaffold(
        body: Center(
          child: ListView(
            children: <Widget>[
              Text(
                a.user.firstName
              ),
              Text(
                a.user.lastName
              ),
              Text(
                a.user.email
              ),
              Text(
                a.user.identityToken
              ),
              Text(
                a.user.accessToken
              ),
              Text(
                a.user.refreshToken
              ),
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            a.logout()
            .then((res) {
              Navigator.of(context).pushNamedAndRemoveUntil(Constants.HOME, (Route<dynamic> route) => false);
            });
          }
        )
      )
    );
  }
}