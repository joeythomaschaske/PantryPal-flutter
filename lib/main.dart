import 'package:flutter/material.dart';
import './sharedServices/Auth.dart';
import './sharedServices/Environment.dart';
import './screens/Root/Root.dart';
import './contstants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'utilities/JWT.dart';
import 'utilities/ApiGateway.dart';
import 'models/User.dart';

void main() async {
  User u;
  final storage = new FlutterSecureStorage();
  List results = await Future.wait([
    storage.read(key: 'idToken'),
    storage.read(key: 'accessToken'),
    storage.read(key: 'refreshToken'),
    storage.read(key: 'firstName'),
    storage.read(key: 'lastName'),
    storage.read(key: 'email'),
    storage.read(key: 'refreshTokenExpiration')
  ]);
  if (results != null &&
      results[0] != null &&
      results[1] != null &&
      results[2] != null &&
      results[3] != null &&
      results[4] != null &&
      results[5] != null &&
      results[6] != null) {
    u = new User(results[3], results[4], results[5], results[0], results[1], results[2], results[6]);
    bool idTokenActive = JWT.isActive(results[0]);
    bool refreshTokenActive = JWT.refreshTokenActive(results[6]);
    if (!idTokenActive && !refreshTokenActive) {
      await storage.deleteAll();
    } else if (!idTokenActive && refreshTokenActive) {
      Map<String, dynamic> newTokens = await ApiGateway.refreshOutsideApp(results[5], PROD_API_BASE_URL, results[2]);
      if (newTokens['error'] != null) {
        await storage.deleteAll();
      } else {
        u.identityToken = newTokens['idToken'];
        u.accessToken =newTokens['accessToken'];
        u.refreshToken = newTokens['refreshToken'];
        u.refreshTokenExpiration = newTokens['refreshTokenExpiration'];
        await storage.write(key: 'idToken', value: newTokens['idToken']);
        await storage.write(key: 'accessToken', value: newTokens['accessToken']);
        await storage.write(key: 'refreshToken', value: newTokens['refreshToken']);
        await storage.write(key: 'refreshTokenExpiration', value: newTokens['refreshTokenExpiration'].toString());
      }
      
    }
  }

  return runApp(
    EnvironmentContainer(
      baseUrl: PROD_API_BASE_URL, 
      child: AuthContainer(
        user: u,
        child: Root()
      )
    )
  );
}
