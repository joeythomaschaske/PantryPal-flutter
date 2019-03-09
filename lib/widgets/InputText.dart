import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final String error;
  final Function validator;
  final bool password;

  InputText(
      {@required this.controller,
      this.hint,
      this.label,
      this.validator,
      this.error,
      this.password})
      : super();

  @override
  InputTextState createState() => InputTextState();
}

class InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: this.widget.password != null ? this.widget.password : false,
        controller: this.widget.controller,
        onChanged: (email) => this.widget.validator(email),
        decoration: InputDecoration(
          labelText: this.widget.label,
          hintText: this.widget.hint,
          hintStyle: TextStyle(color: Colors.black),
          errorText: this.widget.error,
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
          enabledBorder: InputBorder.none,
          labelStyle: TextStyle(
            color: Colors.black
          )
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 20
        ),
      );
  }
}
