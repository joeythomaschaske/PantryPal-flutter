import 'package:flutter/material.dart';

class RenderIf extends StatelessWidget {
  final bool isTrue;
  final Widget child;

  RenderIf({@required this.isTrue, @required this.child});

  @override
  Widget build(BuildContext build) {
    Widget displayedWidget = isTrue ? child : null;
    return displayedWidget;
  }
}