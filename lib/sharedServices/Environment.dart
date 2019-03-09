import 'package:flutter/material.dart';

class _InheritedEnvironmentContainer extends InheritedWidget {
  final EnvironmentContainerState data;

  _InheritedEnvironmentContainer({
    Key key,
    @required this.data,
    @required Widget child
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedEnvironmentContainer old) => true;
}

class EnvironmentContainer extends StatefulWidget {
  final Widget child;
  final String baseUrl;

  EnvironmentContainer({
    @required this.child,
    @required this.baseUrl
  });

  static EnvironmentContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedEnvironmentContainer) as _InheritedEnvironmentContainer).data;
  }

  @override
  EnvironmentContainerState createState() => new EnvironmentContainerState(baseUrl:baseUrl);
}

class EnvironmentContainerState extends State<EnvironmentContainer> {
  String baseUrl;

  EnvironmentContainerState({
    @required this.baseUrl
  });

  @override
  Widget build(BuildContext context) {
    return new _InheritedEnvironmentContainer(
      data : this,
      child: widget.child
    );
  }
}