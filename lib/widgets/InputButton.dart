import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final String text;
  final Function onPress;

  InputButton(this.text, this.onPress) : super();

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
            onPressed: onPress,
            child: SizedBox(width: double.infinity, child: Center(child:Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ))),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)));
  }
}