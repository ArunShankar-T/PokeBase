import 'package:flutter/foundation.dart';

class PokemonFavorite {
  late int id;
  late String name;
  late String imageUrl;
  late String pokemonDetailMapString;

  PokemonFavorite(
      this.id, this.name, this.imageUrl, this.pokemonDetailMapString);

  PokemonFavorite.fromMap(Map<String, dynamic> json) {
    try {
      name = json['name'] ?? "";
      imageUrl = json['image_url'] ?? "";
      pokemonDetailMapString = json['pokemon_details'] ?? "";
      id = json['id'] ?? 0;
    } catch (e) {
      debugPrint("$e");
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['pokemon_details'] = pokemonDetailMapString;
    return data;
  }
}
