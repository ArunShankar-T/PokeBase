import 'package:get/get.dart';
import 'package:poke_base/model/pokemon_list.dart';
import 'package:poke_base/services/remote_services.dart';

class PokemonController extends GetxController {
  var pokemonList = PokemonList().obs;
  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemon();
  }

  void fetchPokemon() async {
    try {
      isLoading(true);
      //Fetch from Api
      pokemonList.value = await RemoteServices().fetchPokemon();
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
