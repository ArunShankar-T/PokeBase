import 'package:get/get.dart';
import 'package:poke_base/helper/sq_lite_helper.dart';
import 'package:poke_base/model/pokemon_favorite.dart';
import 'package:poke_base/model/pokemon_list.dart';
import 'package:poke_base/services/remote_services.dart';
import 'package:poke_base/utils/view_utils.dart';

class PokemonListController extends GetxController {
  var pokemonList = PokemonList(pokemon: <Pokemon>[]).obs;
  var favPokemonIds = List.empty();
  var isLoading = true.obs;
  var isError = false.obs;
  SQLiteHelper sqLiteDb = SQLiteHelper.getSQLiteHelper();

  @override
  void onInit() {
    super.onInit();
    /// To initiate fetch pokemon api.
    fetchPokemon();
  }

  /// To fetch pokemon list from api. Takes [nextRequestUrl] as params.
  /// Returns [PokemonList].
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
      await updateFav();
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

  /// To add the given item [Pokemon] into the database.
  addFavPokemon(Pokemon pokemonItem) async {
    try {
      /// This will convert the image into base64 string to store it in database.
      var base64Image = await RemoteServices().networkImageToBase64(
          ViewUtils.getPokemonImageUrl(pokemonItem.pokemonId));
      if (await sqLiteDb.insertFavPokemon(PokemonFavorite(pokemonItem.pokemonId,
              pokemonItem.name ?? "", base64Image ?? "")) !=
          0) {
        await updateFav();
      }
    } catch (e) {
      print(e);
    }
  }

  /// To delete the pokemon from the database which has the [id].
  removeFavPokemon(int pokemonId) async {
    try {
      if (await sqLiteDb.deleteFavPokemon(pokemonId) != 0) {
        await updateFav();
      }
    } catch (e) {
      print(e);
    }
  }


  /// Update the Favorite Icon on pokemon list.
  Future<void> updateFav() async {
    favPokemonIds = await sqLiteDb.getFavPokemonIds();
    for (var element in pokemonList.value.pokemon) {
      element.isFav = favPokemonIds.contains(element.pokemonId);
    }
    update();
  }
}
