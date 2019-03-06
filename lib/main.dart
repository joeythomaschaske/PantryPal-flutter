import 'package:flutter/material.dart';
import './sharedServices/Auth.dart';
import './sharedServices/Environment.dart';
import './screens/Root/Root.dart';
import './contstants.dart';

void main() => runApp(
  EnvironmentContainer(
    baseUrl: PROD_API_BASE_URL,
    child: AuthContainer(
      child:Root()
    )
  )
  
);