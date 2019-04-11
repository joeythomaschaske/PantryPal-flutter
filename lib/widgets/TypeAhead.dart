import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Flexible(child:
    TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: searchController,
        autofocus: false,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20
        ),
        decoration: InputDecoration(
          hintText: this.widget.hint,
          hintStyle: TextStyle(color: Colors.black),
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
        )
      ),
      suggestionsCallback: (query) {
        List resultingSet = List();
        if (query != null && query.length > 0) {
          resultingSet = widget.items.where((item) {
            return item.name.toString().toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
        if (resultingSet.length == 0 && query != null && query.length > 0 && widget.defaultItem != null) {
          resultingSet.add(widget.defaultItem);
        }
        return resultingSet;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name),
        );
      },
      onSuggestionSelected: (suggestion) {
        searchController.clear();
        widget.onClick(suggestion);
      },
    ));
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}