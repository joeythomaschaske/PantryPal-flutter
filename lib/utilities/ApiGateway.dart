import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../sharedServices/Environment.dart';
import '../sharedServices/Auth.dart';
import './JWT.dart';
import 'dart:convert';

class ApiGateway {
  static Future<String> signUp(String firstName, String lastName, String email, String password, BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    final response = await http.post(environment.baseUrl + '/signUp',
      body : json.encode({
        'firstName' :firstName,
        'lastName' :lastName,
        'email' :email,
        'password' : password
      })
    );

    if (response.statusCode == 200) {
      return 'ok';
    } else if (response.statusCode == 403) {
      return 'duplicate';
    } else {
      return 'error';
    }
  }

  static Future<Map<String, dynamic>> signIn(String email, String password, BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    String url = environment.baseUrl + '/signIn';
    print(url);
    final response = await http.post(url,
      body : json.encode({
        "email" : email,
        "password" : password
      })
    );
    return json.decode(response.body);
  }

  static Future<bool> refresh(BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    AuthContainerState auth = AuthContainer.of(context);
    final response = await http.post(environment.baseUrl + '/refresh',
      body : json.encode({
        'email' :auth.user.email,
        'refreshToken' : auth.user.refreshToken
      })
    );
    
    Map<String, dynamic> body = json.decode(response.body);
    if (body.containsKey('error')) {
      return false;
    }

    String refreshToken = body['refreshToken'];
    String accessToken = body['accessToken'];
    String identityToken = body['identityToken'];
    auth.updateUserTokens(identityToken: identityToken, accessToken: accessToken, refreshToken: refreshToken);
    return true;
  }

  static Future<bool> signOut(BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    AuthContainerState auth = AuthContainer.of(context);

    if (!JWT.isActive(auth.user.identityToken)) {
      await ApiGateway.refresh(context);
    }
    final response = await http.post(environment.baseUrl + '/signOut',
      headers: {
        'Authorization' : 'Bearer ' + auth.user.identityToken
      },
      body : json.encode({
        'idToken' :auth.user.identityToken,
        'accessToken' :auth.user.accessToken,
        'refreshToken' : auth.user.refreshToken
      })
    );
    
    Map<String, dynamic> body = json.decode(response.body);
    if (body.containsKey('error')) {
      return false;
    }
    return true;
  }
}


