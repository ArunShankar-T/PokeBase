class PokemonFavorite {
  late int id;
  late String name;
  late String imageBase64;

  PokemonFavorite(this.id, this.name, this.imageBase64);

  PokemonFavorite.fromMap(Map<String, dynamic> json) {
    try {
      name = json['name'] ?? "";
      imageBase64 = json['image_base64'] ?? "";
      id = json['id'] ?? 0;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['image_base64'] = imageBase64;
    return data;
  }
}
