import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/controller/pokemon_controller.dart';
import 'package:poke_base/utils/view_utils.dart';
import 'package:poke_base/view/pokemon_detail_page.dart';

import '../utils/app_strings.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _pokemonController = Get.put(PokemonController());
    bool hasMore = _pokemonController.pokemonList.value.nextRequestUrl != null;
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pokemonController.fetchPokemon(
            nextRequestUrl:
                _pokemonController.pokemonList.value.nextRequestUrl);
      }
    });
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
      Expanded(child: GetBuilder<PokemonController>(builder: (_) {
        hasMore = _pokemonController.pokemonList.value.nextRequestUrl != null;
        if (_pokemonController.isError.value) {
          return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/connection_error.png',
                    width: 60, height: 60),
                const SizedBox(height: 20),
                const Text(AppStrings.API_ERROR)
              ]);
        } else if (_pokemonController.isLoading.value && !hasMore) {
          return ViewUtils.loader();
        } else {
          var listSize = _pokemonController.pokemonList.value.pokemon.length;
          return ListView.builder(
            itemCount: listSize + (hasMore ? 1 : 0),
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index < listSize) {
                var pokemonItem =
                    _pokemonController.pokemonList.value.pokemon[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => const PokemonDetailPage(),
                        arguments: pokemonItem.pokemonId);
                  },
                  child: Card(
                      color: Colors.redAccent,
                      shadowColor: Colors.black,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                                    child: Text(pokemonItem.name ?? "",
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
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(75),
                                              bottomLeft: Radius.circular(75),
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              ViewUtils.getPokemonImageUrl(
                                                  pokemonItem.pokemonId),
                                          width: 100,
                                          fit: BoxFit.fitHeight,
                                          placeholder: (BuildContext context,
                                                  String url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 1.0)),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error,
                                                  size: 50)),
                                    ))
                              ]),
                          GestureDetector(
                            onTap: () {
                              if (pokemonItem.isFav) {
                                _pokemonController
                                    .removeFavPokemon(pokemonItem.pokemonId);
                              } else {
                                _pokemonController.addFavPokemon(pokemonItem);
                              }
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(boxShadow: const [
                                  BoxShadow(color: Colors.black12)
                                ], borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                    child: _pokemonController.pokemonList.value
                                            .pokemon[index].isFav
                                        ? const Icon(Icons.favorite_outlined,
                                            size: 17)
                                        : const Icon(Icons.favorite_border,
                                            size: 17)),
                              ),
                            ),
                          )
                        ]),
                      )),
                );
              } else {
                return Padding(
                    padding: const EdgeInsets.all(30),
                    child: ViewUtils.loader());
              }
            },
          );
        }
      })),
    ]));
  }
}
