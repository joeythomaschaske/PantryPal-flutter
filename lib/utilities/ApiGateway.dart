import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../sharedServices/Environment.dart';
import '../sharedServices/Auth.dart';
import './JWT.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/Ingredient.dart';
import '../models/PersonIngredient.dart';

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
      return 'An account already exists for this email.\nDid you mean to sign in?';
    } else {
      return 'Unexpected Error';
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

  static Future<Map<String, dynamic>> refreshOutsideApp(String email, String baseUrl, String refreshToken) async {
    final response = await http.post(baseUrl + '/refresh',
      body : json.encode({
        'email' : email,
        'refreshToken' : refreshToken
      })
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> refresh(BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    AuthContainerState auth = AuthContainer.of(context);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String refreshToken = await storage.read(key: 'refreshToken');

    final response = await http.post(environment.baseUrl + '/refresh',
      body : json.encode({
        'email' :auth.user.email,
        'refreshToken' : refreshToken
      })
    );
    
    Map<String, dynamic> body = json.decode(response.body);

    refreshToken = body['refreshToken'];
    String accessToken = body['accessToken'];
    String identityToken = body['identityToken'];
    String refreshTokenExpiration = body['refreshTokenExpiration'].toString();

    await storage.write(key: refreshToken, value: refreshToken);
    await storage.write(key: accessToken, value: accessToken);
    await storage.write(key: identityToken, value: identityToken);
    await storage.write(key: refreshTokenExpiration, value: refreshTokenExpiration);

    return body;
  }

  static Future<bool> signOut(BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String refreshToken = await storage.read(key: 'refreshToken');
    String identityToken = await storage.read(key: 'idToken');
    String accessToken = await storage.read(key: 'accessToken');

    if (!JWT.isActive(identityToken)) {
      Map<String, dynamic> newTokens = await ApiGateway.refresh(context);
      refreshToken = newTokens['refreshToken'];
      identityToken = newTokens['identityToken'];
      accessToken = newTokens['accessToken'];
    }
    final response = await http.post(environment.baseUrl + '/signOut',
      headers: {
        'Authorization' : 'Bearer ' + identityToken
      },
      body : json.encode({
        'idToken' : identityToken,
        'accessToken' :accessToken,
        'refreshToken' : refreshToken
      })
    );
    await storage.deleteAll();
    Map<String, dynamic> body = json.decode(response.body);
    if (body.containsKey('error')) {
      return false;
    }
    return true;
  }
  static Future<List<Ingredient>> getIngredients(BuildContext context) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String identityToken = await storage.read(key: 'idToken');

    if (!JWT.isActive(identityToken)) {
      Map<String, dynamic> newTokens = await ApiGateway.refresh(context);
      identityToken = newTokens['identityToken'];
    }
    final response = await http.get(environment.baseUrl + '/getAllIngredients',
      headers: {
        'Authorization' : 'Bearer ' + identityToken
      },
    );
    Map<String, dynamic> result = json.decode(response.body);
    List rawIngredients = result['ingredients'];

    List<Ingredient> ingredients = rawIngredients.map((ingredient) {
      return Ingredient.fromJson(ingredient);
    }).toList();
    return ingredients;
  }

  static Future<List<PersonIngredient>> createUserIngredients(BuildContext context, List<PersonIngredient> ingredients) async {
    EnvironmentContainerState environment = EnvironmentContainer.of(context);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String identityToken = await storage.read(key: 'idToken');

    if (!JWT.isActive(identityToken)) {
      Map<String, dynamic> newTokens = await ApiGateway.refresh(context);
      identityToken = newTokens['identityToken'];
    }

    final response = await http.post(environment.baseUrl + '/createPersonIngredients',
      headers: {
        'Authorization' : 'Bearer ' + identityToken
      },
      body : json.encode({
        'ingredients' : ingredients
      })
    );

    Map<String, dynamic> result = json.decode(response.body);
    List rawPersonIngredients = result['ingredients'];

    List<PersonIngredient> personIngredients = rawPersonIngredients.map((ingredient) {
      return PersonIngredient.fromJson(ingredient);
    }).toList();
    return personIngredients;

  }
}

