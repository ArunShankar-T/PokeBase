import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:poke_base/controller/network_controller.dart';
import 'package:poke_base/model/pokemon_detail.dart';
import 'package:poke_base/model/pokemon_list.dart';
import 'package:poke_base/utils/app_strings.dart';
import 'package:poke_base/utils/view_utils.dart';

class RemoteServices {
  static var client = http.Client();
  static var networkController = Get.find<NetworkController>();
  static var pokemonBaseUrl = "https://pokeapi.co/api/v2/";
  static var pokemonListEndPoint = pokemonBaseUrl + "pokemon?offset=0&limit=20";
  static var pokemonDetailsEndPoint = pokemonBaseUrl + "pokemon/";

  /// Fetches pokemon list from the url.
  ///
  /// By passing [nextRequestUrl] with Offset and Limit, the api will return the result.
  Future<PokemonList> fetchPokemon(String? nextRequestUrl) async {
    try {
      if (await networkController.isNetworkConnected()) {
        var response =
            await client.get(Uri.parse(nextRequestUrl ?? pokemonListEndPoint));
        if (response.statusCode == 200) {
          return PokemonList.fromJson(json.decode(response.body));
        } else {
          throw Exception(AppStrings.EXCEPTION_UNKNOWN);
        }
      } else {
        ViewUtils.showNoNetworkMessage();
        throw Exception(AppStrings.EXCEPTION_NO_NETWORK);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches pokemon detail from the url.
  ///
  /// By passing [pokemonId] the api will return the result.
  Future<PokemonDetails> fetchPokemonDetails(int pokemonId) async {
    try {
      if (await networkController.isNetworkConnected()) {
        var response =
            await client.get(Uri.parse("$pokemonDetailsEndPoint$pokemonId"));
        if (response.statusCode == 200) {
          return PokemonDetails.fromJson(json.decode(response.body));
        } else {
          throw Exception("Something went wrong while fetching pokemon");
        }
      } else {
        ViewUtils.showNoNetworkMessage();
        throw Exception(AppStrings.EXCEPTION_NO_NETWORK);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches pokemon image from the image url.
  ///
  /// By passing [imageUrl] the api will return the image and
  /// it will be encode as [base64Encode] to store the image in database.
  Future<String?> networkImageToBase64(String imageUrl) async {
    try {
      if (await networkController.isNetworkConnected()) {
        http.Response response = await http.get(Uri.parse(imageUrl));
        final bytes = response.bodyBytes;
        return (bytes != null ? base64Encode(bytes) : null);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
