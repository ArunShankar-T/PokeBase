import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poke_base/model/pokemon_list.dart';

class RemoteServices {
  static var client = http.Client();
  static var endPoint = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20";

  Future<PokemonList> fetchPokemon(String? nextRequestUrl) async {
    try {
      var response = await client.get(Uri.parse(nextRequestUrl ?? endPoint));
      if (response.statusCode == 200) {
        return PokemonList.fromJson(json.decode(response.body));
      } else {
        throw Exception("Something went wrong while fetching pokemon");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
