class Ingredient {
  int id;
  String name;

  Ingredient({this.id, this.name});

  Ingredient.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'];
}