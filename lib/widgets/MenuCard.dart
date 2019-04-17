import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
final String text;
final IconData icon;
final Color color;

  MenuCard(this.text, this.icon, this.color) :super();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double cardWidth = (width - 30) / 2;
    return Container(
      margin: EdgeInsets.all(5),
      color: this.color.withOpacity(.9),
      child: Container(
        height: cardWidth, 
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                this.icon,
                size: 50,
                color: Colors.white,
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              )
            ],
          ),
        )
      )
    );
  }
}