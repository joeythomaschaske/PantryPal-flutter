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


  Future<bool> loadAuthFromStorage() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
    List results = await Future.wait([
      storage.read(key: 'idToken'),
      storage.read(key: 'accessToken'), 
      storage.read(key: 'refreshToken'),
      storage.read(key: 'firstName'),
      storage.read(key: 'lastName'),
      storage.read(key: 'email'),
      storage.read(key: 'refreshTokenExpiration')
    ]);
    if (results != null && results[0] != null && results[1] != null && results[2] != null) {
      updateUserInfo(
        identityToken: results[0], 
        accessToken: results[1], 
        refreshToken: results[2],
        firstName: results[3],
        lastName: results[4],
        email: results[5],
        refreshTokenExpiration: results[6]
      );
      return (JWT.isActive(results[0]) || JWT.refreshTokenActive(results[6]));
    }
    return false;
  }

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
          refreshTokenExpiration: res['refreshTokenExpiration']
        );
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

  Future<void> updateUserTokens({identityToken, accessToken, refreshToken, refreshTokenExpiration}) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'idToken', value: identityToken);
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'refreshTokenExpiration', value: refreshTokenExpiration);
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
    await storage.write(key: 'refreshTokenExpiration', value: refreshTokenExpiration);
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