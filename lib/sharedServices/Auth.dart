import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  bool updateShouldNotify(_InheritedAuthContainer old) {
    return true;
  }
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
  AuthContainerState createState() => new AuthContainerState(user: this.user);
}

class AuthContainerState extends State<AuthContainer> {
  User user;

  AuthContainerState({
    this.user
  });

  bool isAuthenticated() {
    return user != null && (JWT.isActive(user.identityToken) || JWT.refreshTokenActive(user.refreshTokenExpiration));
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
        await updateUserInfo(
          firstName: res['firstName'],
          lastName: res['lastName'],
          email: res['email'],
          identityToken: res['idToken'],
          accessToken: res['accessToken'], 
          refreshToken: res['refreshToken'],
          refreshTokenExpiration: res['refreshTokenExpiration'].toString()
        );
        return 'ok';
      }
    } catch(e) {
      print(e);
      return 'Unexpected Error';
    }
  }

  Future<bool> logout(BuildContext context) async {
    //call api logout method
    bool res = await ApiGateway.signOut(context);
    if (res) {
      final storage = new FlutterSecureStorage();
      await storage.deleteAll();
      setState(() {
        user = null;
      });
    }
    return res;
  }

  Future<void> updateUserTokens({identityToken, accessToken, refreshToken, refreshTokenExpiration}) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'idToken', value: identityToken);
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'refreshTokenExpiration', value: refreshTokenExpiration.toString());
    setState(() {
      user.identityToken = identityToken;
      user.accessToken = accessToken;
      user.refreshToken = refreshToken;
      user.refreshTokenExpiration = refreshTokenExpiration;
    });
  }

  Future <void> updateUserInfo({firstName, lastName, email, identityToken, accessToken, refreshToken, refreshTokenExpiration}) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'idToken', value: identityToken);
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'firstName', value: firstName);
    await storage.write(key: 'lastName', value: lastName);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'refreshTokenExpiration', value: refreshTokenExpiration.toString());
    if (user != null) {
      setState(() {
        user.firstName = firstName;
        user.lastName = lastName;
        user.email = email;
        user.identityToken = identityToken;
        user.accessToken =accessToken;
        user.refreshToken =refreshToken;
        user.refreshTokenExpiration =refreshTokenExpiration;
      });
    } else {
      setState(() {
        user = new User(firstName, lastName, email, identityToken, accessToken, refreshToken, refreshTokenExpiration);
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