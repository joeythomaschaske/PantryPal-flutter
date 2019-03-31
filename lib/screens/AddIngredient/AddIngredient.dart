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
  Ingredient selectedIngredient;
  Ingredient otherIngredient;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ApiGateway.getIngredients(context)
    .then((ingredients) {
      Ingredient other = ingredients.where((ingredient) => ingredient.name == 'Other').toList()[0];
      setState(() {
        this.otherIngredient = other;
        this.ingredients = ingredients;
        loaded = true;
      });
    });
  }

  void ingredientSelected(Ingredient selectedIngredient) {
    setState(() {
      this.selectedIngredient = selectedIngredient;
    });
  }

  @override
  Widget build(BuildContext context) {
    double quarterHeight = MediaQuery.of(context).size.height * .25;
    return Container(
      color: Colors.lightBlue,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text('Add Ingredients'),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: quarterHeight - 25,
            left: 0,
            child: Text('SELECTED INGREDIENT: ' + (selectedIngredient != null ? selectedIngredient.name : 'none'))
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: quarterHeight - 75,
            left: 0,
            child: Center(
              
              child: Container(
              width: MediaQuery.of(context).size.width * .75,
              child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: TypeAhead(
                      hint: 'Ingredient Name',
                      items: ingredients,
                      onClick: ingredientSelected,
                      defaultItem: otherIngredient,
                    )
                  )
                )
              ]
            )
          )))
        ],
      )
    );
  }
}