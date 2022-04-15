import 'package:poke_base/model/pokemon.dart';

class PokemonList {
  String? nextRequestUrl;
  List<Pokemon> pokemon = <Pokemon>[];

  PokemonList({this.nextRequestUrl, required this.pokemon});

  PokemonList.fromJson(Map<String, dynamic> json) {
    nextRequestUrl = json['next'];
    if (json['results'] != null) {
      json['results'].forEach((v) {
        pokemon.add(Pokemon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['next'] = nextRequestUrl;
    data['results'] = pokemon.map((v) => v.toJson()).toList();
    return data;
  }
}
