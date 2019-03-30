import 'package:flutter/material.dart';
import './InputText.dart';

class TypeAhead extends StatefulWidget {
  final List items;
  final String hint;
  TypeAhead({@required this.items, this.hint}) : super();

  @override
  TypeAheadState createState() => TypeAheadState();
}

class TypeAheadState extends State<TypeAhead> {
  TextEditingController searchController = new TextEditingController();
  List matchingItems = List();

  void search(String query) {
    List resultingSet = widget.items.where((item) {
      return item.name.toString().toLowerCase().contains(query.toLowerCase());

    }).toList();
    setState(() {
      matchingItems = resultingSet;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InputText(
            controller: searchController,
            hint: widget.hint,
            onChange: search,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: matchingItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Text(
                        matchingItems[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    );
                  },
                ),
              )
            ],
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}