import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poke_base/model/pokemon_detail.dart';
import 'package:poke_base/model/pokemon_list.dart';

class RemoteServices {
  static var client = http.Client();
  static var pokemonBaseUrl = "https://pokeapi.co/api/v2/";
  static var pokemonListEndPoint = pokemonBaseUrl + "pokemon?offset=0&limit=20";
  static var pokemonDetailsEndPoint = pokemonBaseUrl + "pokemon/";

  Future<PokemonList> fetchPokemon(String? nextRequestUrl) async {
    try {
      var response =
          await client.get(Uri.parse(nextRequestUrl ?? pokemonListEndPoint));
      if (response.statusCode == 200) {
        return PokemonList.fromJson(json.decode(response.body));
      } else {
        throw Exception("Something went wrong while fetching pokemon");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PokemonDetails> fetchPokemonDetails(int pokemonId) async {
    try {
      var response =
          await client.get(Uri.parse("$pokemonDetailsEndPoint$pokemonId"));
      if (response.statusCode == 200) {
        return PokemonDetails.fromJson(json.decode(response.body));
      } else {
        throw Exception("Something went wrong while fetching pokemon");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
