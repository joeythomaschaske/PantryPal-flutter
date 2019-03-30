class Ingredient {
  int id;
  String name;

  Ingredient({this.id, this.name});

  Ingredient.fromJson(Map<String, dynamic> json) :
    id = int.parse(json['id']),
    name = json['name'];
}