import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poke_base/model/pokemon_list.dart';

class RemoteServices {
  static var client = http.Client();
  static var baseUrl = "https://pokeapi.co/api/v2/";

  Future<PokemonList> fetchPokemon() async {
    var response = await client.get(Uri.parse(baseUrl + "pokemon"));
    if (response.statusCode == 200) {
      return PokemonList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Something went wrong while fetching pokemon");
    }
  }
}
