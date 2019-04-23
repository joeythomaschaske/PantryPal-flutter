class PersonIngredient {
  int id;
  int ingredientId;
  String ingredient;
  String customIngredient;

  PersonIngredient({this.id, this.ingredientId, this.customIngredient});

  PersonIngredient.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    ingredientId = json['ingredientId'],
    customIngredient = json['customIngredient'];

  Map<String, dynamic> toJson() => {
    'id' :id,
    'ingredientId' : ingredientId,
    'customIngredient' : customIngredient
  };
}