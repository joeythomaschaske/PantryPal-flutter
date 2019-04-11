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
  List<Ingredient> ingredients = List<Ingredient>();
  List<Ingredient> selectedIngredients = List<Ingredient>();
  Ingredient otherIngredient;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void ingredientSelected(Ingredient selectedIngredient) {
    selectedIngredients.add(selectedIngredient);
    setState(() {
      this.selectedIngredients = selectedIngredients;
    });
  }

  void addIngredients() async {
    List<PersonIngredient> personIngredientsToInsert = List<PersonIngredient>();
    selectedIngredients.forEach((ingredient) {
      PersonIngredient personIngredient = PersonIngredient();
      personIngredient.ingredientId = ingredient.id;
      personIngredientsToInsert.add(personIngredient);
    }); 

    List<PersonIngredient> insertedIngredients = await ApiGateway.createUserIngredients(context, personIngredientsToInsert);
    print('we inserted them');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 50),
      height: MediaQuery.of(context).size.height,
       decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                image: AssetImage('assets/spices.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(.2), BlendMode.dstATop))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              TypeAhead(
                hint: 'Search Ingredients',
                items: ingredients,
                onClick: ingredientSelected,
                defaultItem: otherIngredient,
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
                      Text(
                        'Ingredients Selected',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1
                        )
                      ),
                      Flexible(child:ListView.builder(
                        itemCount: selectedIngredients.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              selectedIngredients[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),
                            ),
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
                child: InputButton(
                  'Save Ingredients',
                  addIngredients,
                  Colors.white
                )
              )
            ],
          )
        ],
      )
    );
  }
}