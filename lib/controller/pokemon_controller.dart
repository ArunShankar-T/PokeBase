import 'package:get/get.dart';
import 'package:poke_base/model/pokemon.dart';

class PokemonController extends GetxController {
  var cartItems = List.empty(growable: true).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemon();
  }

  void fetchPokemon() async {
    isLoading(true);
    //Fetch from Api
    isLoading(false);
  }
}
