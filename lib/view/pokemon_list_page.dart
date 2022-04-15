import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/controller/pokemon_controller.dart';

import '../utils/app_strings.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pokemonController = Get.put(PokemonController());
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 80),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(AppStrings.APP_TITLE,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24)))),
      const SizedBox(height: 20),
      Expanded(child: Obx(() {
        print("XX isError  ${pokemonController.isError.value}");
        print("XX isLoading   ${pokemonController.isLoading.value}");
        if (pokemonController.isError.value) {
          return const Center(child: Text(AppStrings.API_ERROR_POKEMON_LIST));
        } else if (pokemonController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          print("XX ListView.builder");
          return ListView.builder(
            itemCount: pokemonController.pokemonList.value.pokemon?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              var pokemonItem =
                  pokemonController.pokemonList.value.pokemon?[index];
              return Card(
                  color: Colors.redAccent,
                  shadowColor: Colors.black,
                  elevation: 5,
                  borderOnForeground: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Stack(children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(pokemonItem?.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                              flex: 2,
                              child: Image.network(
                                  AppStrings.POKEMON_IMAGE_URL.replaceAll(
                                      AppStrings.POKEMON_ID_PLACEHOLDER,
                                      pokemonItem?.pokemonId.toString() ?? ""),
                                  width: 100,
                                  fit: BoxFit.fitHeight, loadingBuilder:
                                      ((context, child, loadingProgress) {
                                return loadingProgress == null
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1.0));
                              }), errorBuilder: ((context, error, stackTrace) {
                                return const Icon(Icons.error, size: 50);
                              })))
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(boxShadow: const [
                            BoxShadow(color: Colors.black12)
                          ], borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                              child: Icon(Icons.favorite_border, size: 17)),
                        ),
                      )
                    ]),
                  ));
            },
          );
        }
      })),
    ]));
  }
}
