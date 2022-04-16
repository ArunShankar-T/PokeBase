import 'package:get/get.dart';
import 'package:poke_base/helper/sq_lite_helper.dart';
import 'package:poke_base/model/pokemon_favorite.dart';
import 'package:poke_base/model/pokemon_list.dart';
import 'package:poke_base/services/remote_services.dart';
import 'package:poke_base/utils/view_utils.dart';

class PokemonController extends GetxController {
  var pokemonList = PokemonList(pokemon: <Pokemon>[]).obs;
  var favPokemonIds = List.empty();
  var isLoading = true.obs;
  var isError = false.obs;
  SQLiteHelper sqLiteDb = SQLiteHelper.getSQLiteHelper();

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
      favPokemonIds = await sqLiteDb.getFavPokemonIds();
      var tempPokemonList = pokemonList.value;
      tempPokemonList.nextRequestUrl = pokemonListResponse.nextRequestUrl;
      tempPokemonList.pokemon.insertAll(
          tempPokemonList.pokemon.length, pokemonListResponse.pokemon);
      _updateFav(tempPokemonList);
      if (isError.value) {
        isError(false);
      }
    } catch (e) {
      isError(true);
    } finally {
      isLoading(false);
    }
    update();
  }

  addFavPokemon(Pokemon pokemonItem) async {
    try {
      var base64Image = await RemoteServices().networkImageToBase64(
          ViewUtils.getPokemonImageUrl(pokemonItem.pokemonId));
      if (await sqLiteDb.insertFavPokemon(PokemonFavorite(pokemonItem.pokemonId,
              pokemonItem.name ?? "", base64Image ?? "")) !=
          0) {
        favPokemonIds.addIf(!favPokemonIds.contains(pokemonItem.pokemonId),
            pokemonItem.pokemonId);
        _updateFav(pokemonList.value);
        update();
      }
    } catch (e) {
      print("$e");
    }
  }

  removeFavPokemon(int pokemonId) async {
    try {
      if (await sqLiteDb.deleteFavPokemon(pokemonId) != 0) {
        favPokemonIds.remove(pokemonId);
        _updateFav(pokemonList.value);
        update();
      }
    } catch (e) {
      print("$e");
    }
  }

  void _updateFav(PokemonList pokemonList) {
    for (var element in pokemonList.pokemon) {
      element.isFav = favPokemonIds.contains(element.pokemonId);
    }
  }
}
