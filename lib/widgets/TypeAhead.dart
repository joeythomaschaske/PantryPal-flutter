import 'package:flutter/material.dart';
import './InputText.dart';

class TypeAhead extends StatefulWidget {
  final List items;
  final String hint;
  final Function onClick;
  final dynamic defaultItem;
  final Key key;
  TypeAhead({@required this.items, this.hint, @required this.onClick, this.defaultItem, this.key}) : super(key : key);

  @override
  TypeAheadState createState() => TypeAheadState();
}

class TypeAheadState extends State<TypeAhead> {
  TextEditingController searchController = new TextEditingController();
  List matchingItems = List();

  void search(String query) {
    List resultingSet = List();
    if (query != null && query.length > 0) {
      resultingSet = widget.items.where((item) {
        return item.name.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    if (resultingSet.length == 0 && query != null && query.length > 0 && widget.defaultItem != null) {
      resultingSet.add(widget.defaultItem);
    }

    setState(() {
      matchingItems = resultingSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget list = matchingItems != null && matchingItems.length > 0 ? (Flexible(child:ListView.builder(
            shrinkWrap: true,
            itemCount: matchingItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onClick(matchingItems[index]);
                  matchingItems.clear();
                  searchController.clear();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, style: BorderStyle.solid)
                    )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          matchingItems[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                        ),
                      )
                    ],
                  )
                ),
              );
            },
          ),)) : Container( height: 0,);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .27,
        minHeight: 0,
        maxWidth: MediaQuery.of(context).size.width,
        minWidth: 0
      ),
      color: Colors.white.withOpacity(.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InputText(
            controller: searchController,
            hint: widget.hint,
            onChange: search,
          ),
          list
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