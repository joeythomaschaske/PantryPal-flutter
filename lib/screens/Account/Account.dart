import 'package:flutter/material.dart';
import '../../sharedServices/Auth.dart';
import '../../widgets/InputButton.dart';
import '../../utilities/ApiGateway.dart';
import '../../contstants.dart' as Constants;
class Account extends StatefulWidget {

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {

  Future<void> signOut() async {
    bool result = await ApiGateway.signOut(context);
    print('Signed Out: ');
    print(result);
    Navigator.of(context).pushNamedAndRemoveUntil(Constants.REGISTER, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    AuthContainerState user = AuthContainer.of(context);
    
    return (
      Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.user.firstName + ' ' + user.user.lastName,
              style: TextStyle(
                fontSize: 20
              ),
            ),
            InputButton('Sign Out', signOut, Colors.red)
          ],
        ),
      )
    );
  }
}