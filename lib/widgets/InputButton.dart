import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color;

  InputButton(this.text, this.onPress, this.color) : super();

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        borderSide: BorderSide(color: this.color, width: 2),
            onPressed: onPress,
            child: SizedBox(width: double.infinity, child: Center(child:Text(
              text,
              style: TextStyle(fontSize: 25, color: this.color),
            ))),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)));
  }
}