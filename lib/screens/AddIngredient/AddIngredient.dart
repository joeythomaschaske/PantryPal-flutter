import 'package:flutter/material.dart';
import '../../widgets/TypeAhead.dart';
import '../../utilities/ApiGateway.dart';
import '../../models/Ingredient.dart';
import '../../models/PersonIngredient.dart';
import '../../widgets/InputButton.dart';

class AddIngredient extends StatefulWidget {
    AddIngredient() : super();

    @override
    AddIngredientState createState() => AddIngredientState();
}

class AddIngredientState extends State<AddIngredient> {
  bool loaded = false;
  bool saving = false;
  List<Ingredient> ingredients = List<Ingredient>();
  List<Ingredient> selectedIngredients = List<Ingredient>();
  Ingredient otherIngredient;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ingredients.length == 0) {
      ApiGateway.getIngredients(context)
      .then((ingredients) {
        print('loaded');
        Ingredient other = ingredients.where((ingredient) => ingredient.name == 'Other').toList()[0];
        setState(() {
          this.otherIngredient = other;
          this.ingredients = ingredients;
          loaded = true;
        });
      });
    }
  }

  Ingredient otherIngredientSearched(Ingredient other, String query) {
    Ingredient copy = other.copy();
    copy.name = copy.name + ' - ' + query;
    return copy;
  }

  void ingredientSelected(Ingredient selectedIngredient) {
    if (selectedIngredient.id == otherIngredient.id) {
        selectedIngredient.name = selectedIngredient.name.replaceAll('Other -', '').trim();
      }
    selectedIngredients.add(selectedIngredient);
    setState(() {
      this.selectedIngredients = selectedIngredients;
    });
  }

  void addIngredients() async {
    setState(() {
      saving = true;
    });
    List<PersonIngredient> personIngredientsToInsert = List<PersonIngredient>();
    selectedIngredients.forEach((ingredient) {
      PersonIngredient personIngredient = PersonIngredient();
      personIngredient.ingredientId = ingredient.id;
      if (ingredient.id == otherIngredient.id) {
        personIngredient.customIngredient = ingredient.name.replaceAll('Other -', '').trim();
      }
      personIngredientsToInsert.add(personIngredient);
    }); 

    await ApiGateway.createUserIngredients(context, personIngredientsToInsert);
    setState(() {
      saving = false;
      selectedIngredients = List<Ingredient>();
    });
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          'Ingredients added to inventory',
          style: TextStyle(
            fontSize: 20
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget saveButtonOrSpinner = saving ? 
      Center(
        child : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
      ) :
      InputButton('Save Ingredients', addIngredients, Colors.white);
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 5),
      height: MediaQuery.of(context).size.height,
       decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                image: AssetImage('assets/spices.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(.2), BlendMode.dstATop))),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(bottom: 50),
        child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              TypeAhead(
                hint: 'Search Ingredients',
                items: ingredients,
                onClick: ingredientSelected,
                defaultItem: otherIngredient,
                defaultCallback: otherIngredientSearched,
              )
            ],
          ),
          Flexible(
            child:Row(
              children: <Widget>[
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Ingredients Selected',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1
                          )
                        ),
                      ),
                      Flexible(child:ListView.builder(
                        itemCount: selectedIngredients.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(index.toString()),
                            background: Container(color: Colors.white.withOpacity(.5), margin: EdgeInsets.only(top: 5)),
                            onDismissed: (direction) {
                              setState(() {
                                selectedIngredients.removeAt(index);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              color: Colors.white,
                              child: ListTile(
                                title: Text(
                                  selectedIngredients[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20
                                  ),
                                ),
                              ),
                            )
                          );
                        },
                      ))
                    ],
                  )
                )
              ],
            )
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: saveButtonOrSpinner
              )
            ],
          )
        ],
      )))
    );
  }
}