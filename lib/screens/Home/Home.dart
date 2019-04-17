import 'package:flutter/material.dart';
import '../../sharedServices/Auth.dart';
import '../../widgets/MenuCard.dart';
import '../../contstants.dart' as Constants;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatelessWidget {
  Home() : super();

  Future<void> openAccount(BuildContext context) async {
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String identityToken = await storage.read(key: 'idToken');
    String refreshTokenExpiration = await storage.read(key: 'refreshTokenExpiration');
    Navigator.of(context).pushNamed(Constants.ACCOUNT, arguments: {
      'identityToken' : identityToken,
      'refreshTokenExpiration' : refreshTokenExpiration
    });
  }

  Future<void> openAddIngredient(BuildContext context) async {
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String identityToken = await storage.read(key: 'idToken');
    String refreshTokenExpiration = await storage.read(key: 'refreshTokenExpiration');
    Navigator.of(context).pushNamed(Constants.ADDINGREDIENT, arguments: {
      'identityToken' : identityToken,
      'refreshTokenExpiration' : refreshTokenExpiration
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthContainerState auth = AuthContainer.of(context);
    TimeOfDay now = TimeOfDay.now();
    String menuOption;
    if (now.hour >= 3 && now.hour < 11) {
      menuOption = 'breakfast';
    } else if (now.hour >= 11 && now.hour < 15) {
      menuOption = 'lunch';
    } else {
      menuOption = 'dinner';
    }
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        padding: EdgeInsets.only(top:deviceHeight * .05, bottom:deviceHeight * .05, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/spices.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.transparent.withOpacity(.8), BlendMode.dstATop))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text("Pantry Pal",
                style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("What's for " + menuOption + " " + auth.user.firstName + "?",
                          style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                     Expanded(
                       child: GestureDetector(
                         onTap: () => openAddIngredient(context),
                         child: MenuCard('Add Ingredients', Icons.shopping_basket, Colors.blue)
                        ) ,
                      ),
                      Expanded(
                       child: MenuCard('Recipes', Icons.local_dining, Colors.red[900]),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                     Expanded(
                       child: MenuCard('Ingredients', Icons.spa, Colors.lightGreen[900]) ,
                      ),
                      Expanded(
                       child: GestureDetector(
                         onTap: () => openAccount(context),
                         child: MenuCard('Account', Icons.person, Colors.amber)
                        ) ,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
