import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/controller/pokemon_fav_controller.dart';
import 'package:poke_base/utils/app_strings.dart';
import 'package:poke_base/utils/view_utils.dart';

class PokemonFavListPage extends StatelessWidget {
  const PokemonFavListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _pokemonFavController = Get.put(PokemonFavController());
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 80),
      Stack(children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(Icons.arrow_back, size: 30),
              )),
        ),
        const Expanded(
          child: Center(
            child: Text(AppStrings.favoritePokemon,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ),
        )
      ]),
      const SizedBox(height: 20),
      Expanded(child: Obx(() {
        var favList = _pokemonFavController.favPokemonList;
        if (_pokemonFavController.isLoading.value) {
          return ViewUtils.loader();
        } else if (favList.isEmpty) {
          return Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/pokemon_ball.png',
                      width: 60, height: 60),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      AppStrings.favoritePokemonEmptyMessage,
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
          );
        } else {
          var listSize = _pokemonFavController.favPokemonList.length;
          return GridView.builder(
            itemCount: listSize,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
            itemBuilder: (BuildContext context, int index) {
              var pokemonItem = _pokemonFavController.favPokemonList[index];
              return Card(
                  color: Colors.redAccent,
                  shadowColor: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Stack(children: [
                      Center(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(75),
                                      topRight: Radius.circular(75),
                                      topLeft: Radius.circular(75),
                                      bottomLeft: Radius.circular(75))),
                              child: pokemonItem.imageBase64.isNotEmpty
                                  ? Image.memory(
                                      ViewUtils.base64StringToBytes(
                                          pokemonItem.imageBase64),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover)
                                  : const Icon(Icons.error, size: 50))),
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                            ViewUtils.firstLetterToUpperCase(pokemonItem.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pokemonFavController
                              .removeFavPokemon(pokemonItem.id);
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(boxShadow: const [
                              BoxShadow(color: Colors.black12)
                            ], borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                                child: Icon(Icons.favorite_outlined, size: 17)),
                          ),
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
