import 'package:get/get.dart';
import 'package:poke_base/helper/sq_lite_helper.dart';
import 'package:poke_base/model/pokemon_favorite.dart';

class PokemonFavController extends GetxController {
  var favPokemonList = <PokemonFavorite>[].obs;
  var isLoading = true.obs;
  SQLiteHelper sqLiteDb = SQLiteHelper.getSQLiteHelper();

  @override
  void onInit() {
    super.onInit();
    /// Fetches the Favorite pokemon.
    fetchFavPokemon();
  }

  /// Fetches the Favorite pokemon from the database.
  fetchFavPokemon({String? nextRequestUrl}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      favPokemonList.value = await sqLiteDb.getFavPokemon();
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  /// To delete the pokemon from the database which has the [pokemonId].
  removeFavPokemon(int pokemonId) async {
    try {
      if (await sqLiteDb.deleteFavPokemon(pokemonId) != 0) {
        favPokemonList.removeWhere((element) => element.id == pokemonId);
      }
    } catch (e) {
      print(e);
    }
  }
}
