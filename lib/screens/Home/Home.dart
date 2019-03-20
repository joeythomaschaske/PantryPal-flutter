import 'package:flutter/material.dart';
import '../../sharedServices/Auth.dart';

class Home extends StatelessWidget {
  Home() : super();

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
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/spices-black.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.transparent.withOpacity(.4), BlendMode.dstATop))),
        child: IntrinsicHeight(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: .05 * deviceHeight,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  "What's for " + menuOption + " " + auth.user.firstName + "?",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
            IntrinsicHeight(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                        Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Card(
                          child:
                              Container(height: 100, child: Text("Option 1")))),
                  Expanded(
                      child: Card(
                          child:
                              Container(height: 100, child: Text("Option 1")))),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Card(
                          child:
                              Container(height: 100, child: Text("Option 1")))),
                  Expanded(
                      child: Card(
                          child:
                              Container(height: 100, child: Text("Option 1")))),
                ],
              )
            ]))
          ],
        )),
      ),
    );
  }
}
