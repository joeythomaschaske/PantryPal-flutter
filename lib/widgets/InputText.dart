import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final String error;
  final Function onChange;
  final bool password;

  InputText(
      {@required this.controller,
      this.hint,
      this.label,
      this.onChange,
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
        onChanged: (value) {
          if (this.widget.onChange != null) {
            this.widget.onChange(value);
          }
        },
        decoration: InputDecoration(
          labelText: this.widget.label,
          hintText: this.widget.hint,
          hintStyle: TextStyle(color: Colors.black),
          errorText: this.widget.error,
          errorStyle: TextStyle(
            fontSize: 20
          ),
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
