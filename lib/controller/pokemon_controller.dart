import 'package:get/get.dart';
import 'package:poke_base/model/pokemon_list.dart';
import 'package:poke_base/services/remote_services.dart';

class PokemonController extends GetxController {
  var pokemonList = PokemonList(pokemon: <Pokemon>[]).obs;
  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemon();
  }

  fetchPokemon({String? nextRequestUrl}) async {
    try {
      isLoading(true);
      //Fetch from Api
      var pokemonListResponse =
          await RemoteServices().fetchPokemon(nextRequestUrl);
      var tempPokemonList = pokemonList.value;
      tempPokemonList.nextRequestUrl = pokemonListResponse.nextRequestUrl;
      tempPokemonList.pokemon.insertAll(
          tempPokemonList.pokemon.length, pokemonListResponse.pokemon);
      pokemonList.value = tempPokemonList;

      if (isError.value) {
        isError(false);
      }
    } catch (e) {
      isError(true);
    } finally {
      isLoading(false);
    }
  }
}
