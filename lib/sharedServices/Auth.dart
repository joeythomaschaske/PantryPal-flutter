import 'package:flutter/material.dart';
import '../models/User.dart';
import '../utilities/JWT.dart';
import '../utilities/ApiGateway.dart';

class _InheritedAuthContainer extends InheritedWidget {
  final AuthContainerState data;

  _InheritedAuthContainer({
    Key key,
    @required this.data,
    @required Widget child
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedAuthContainer old) => true;
}

class AuthContainer extends StatefulWidget {
  final Widget child;
  final User user;

  AuthContainer({
    @required this.child,
    this.user
  });

  static AuthContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedAuthContainer) as _InheritedAuthContainer).data;
  }

  @override
  AuthContainerState createState() => new AuthContainerState();
}

class AuthContainerState extends State<AuthContainer> {
  User user;

  bool isAuthenticated() {
    return user != null && (JWT.isActive(user.identityToken) || JWT.isActive(user.refreshToken));
  }

  Future<String> register(String firstName, String lastName, String email, String password) {
    return ApiGateway.signUp(firstName, lastName, email, password, context);
  }

  Future<String> login(String email, String password, BuildContext context) async {
    //call api and get user info
    try {
      Map<String, dynamic> res = await ApiGateway.signIn(email, password, context);
      if (res.containsKey('error')) {
        return res['error'];
      } else {
        setState(() {
          user = User('Joe', 'Thomaschaske', email, res['idToken'], res['accessToken'], res['refreshToken']);
        });
        return 'ok';
      }
    } catch(e) {
      print(e);
      return 'error';
    }
  }

  Future<bool> logout() async {
    //call api logout method
    bool res = await ApiGateway.signOut(context);
    if (res) {
      setState(() {
        user = null;
      });
    }
    return res;
  }

  void updateUserTokens({identityToken, accessToken, refreshToken}) {
    setState(() {
      user.identityToken = identityToken;
      user.accessToken = accessToken;
      user.refreshToken = refreshToken;
    });
  }

  void updateUserInfo({firstName, lastName, email, identityToken, accessToken, refreshToken}) {
    if (user != null) {
      setState(() {
        user.firstName = firstName;
        user.lastName = lastName;
        user.email = email;
        user.identityToken = identityToken;
      });
    } else {
      setState(() {
        user = new User(firstName, lastName, email, identityToken, accessToken, refreshToken);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedAuthContainer(
      data : this,
      child: widget.child
    );
  }
}