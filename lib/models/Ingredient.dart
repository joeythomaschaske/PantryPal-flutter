class Ingredient {
  int id;
  String name;

  Ingredient({this.id, this.name});

  Ingredient.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'];

    Ingredient copy() {
      Ingredient copy = new Ingredient(id: id, name: name);
      return copy;
    }
}