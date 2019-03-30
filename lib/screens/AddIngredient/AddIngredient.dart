import 'package:flutter/material.dart';
import '../../widgets/TypeAhead.dart';
import '../../utilities/ApiGateway.dart';
import '../../models/Ingredient.dart';

class AddIngredient extends StatefulWidget {
    AddIngredient() : super();

    @override
    AddIngredientState createState() => AddIngredientState();
}

class AddIngredientState extends State<AddIngredient> {
  bool loaded = false;
  List<Ingredient> ingredients = List<Ingredient>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   ApiGateway.getIngredients(context)
   .then((ingredients) {
     setState(() {
       this.ingredients = ingredients;
       loaded = true;
     });
   });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          TypeAhead(hint: 'Ingredient Name', items: ingredients)
        ],
      )
    );
  }
}