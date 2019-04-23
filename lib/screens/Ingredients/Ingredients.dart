import 'package:flutter/material.dart';
import 'package:app/utilities/ApiGateway.dart';
import 'package:app/models/PersonIngredient.dart';


class Ingredients extends StatefulWidget {
  Ingredients() : super();

  @override
  IngredientsState createState() => IngredientsState();

}

class IngredientsState extends State<Ingredients> {
  bool loaded = false;
  List<PersonIngredient> ingredients = List<PersonIngredient>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ingredients.length == 0) {
      ApiGateway.getPersonIngredients(context)
      .then((ingredients) {
        ingredients.sort((a, b)  {
          String ingredientAName = a.ingredient == 'Other' ? a.customIngredient : a.ingredient;
          String ingredientBName = b.ingredient == 'Other' ? b.customIngredient : b.ingredient;
          return ingredientAName.toLowerCase().compareTo(ingredientBName.toLowerCase());
        });
        setState(() {
          this.ingredients = ingredients;
          loaded = true;
        });
      });
    }
  }

  Widget getIngredientListView() {
    return Flexible(
      child: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(ingredients[index].id.toString()),
            background: Container(color: Colors.white.withOpacity(.5), margin: EdgeInsets.only(top: 5)),
            onDismissed: (direction) {
              archiveIngredient(ingredients[index]);
              setState(() {
                ingredients.removeAt(index);
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 5),
              color: Colors.white,
              child: ListTile(
                title: Text(
                  ingredients[index].ingredient != 'Other' ? ingredients[index].ingredient : ingredients[index].customIngredient,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ),
                ),
              ),
            )
          );
        },
      )
    );
  }

  void archiveIngredient(PersonIngredient personIngredient) async {
    bool success = await ApiGateway.archivePersonIngredient(context, personIngredient.id);
    String message = '';
    String ingredient = personIngredient.ingredient == 'Other' ? personIngredient.customIngredient : personIngredient.ingredient;
    if (success) {
      message = ingredient + ' removed!';
    } else {
      message = ingredient + ' was not removed, try again later';
    }
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 20
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget ingredients = loaded ? getIngredientListView() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 5),
      height: MediaQuery.of(context).size.height,
       decoration: BoxDecoration(
            color: Colors.lightGreen[900],
            image: DecorationImage(
                image: AssetImage('assets/spices.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(.2), BlendMode.dstATop))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'My Ingredients',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1
                    )
                  ),
                )
              ),
              ingredients
            ],
          ),
        ),
      )
    );
  }
}