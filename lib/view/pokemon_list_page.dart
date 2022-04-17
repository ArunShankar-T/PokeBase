import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/controller/network_controller.dart';
import 'package:poke_base/controller/pokemon_detail_controller.dart';
import 'package:poke_base/controller/pokemon_list_controller.dart';
import 'package:poke_base/utils/view_utils.dart';
import 'package:poke_base/view/pokemon_detail_page.dart';
import 'package:poke_base/view/pokemon_fav_list_page.dart';

import '../utils/app_strings.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _pokemonListController = Get.put(PokemonListController());
    var networkController = Get.find<NetworkController>();
    ScrollController _scrollController = ScrollController();
    Get.put(PokemonDetailController());
    bool hasMore =
        _pokemonListController.pokemonList.value.nextRequestUrl != null;
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (await networkController.isNetworkConnected()) {
          _pokemonListController.fetchPokemon(
              nextRequestUrl:
                  _pokemonListController.pokemonList.value.nextRequestUrl);
        } else {
          ViewUtils.showNoNetworkMessage();
        }
      }
    });
    return Scaffold(
        body: Stack(children: [
      Container(
        margin: const EdgeInsets.only(left: 120, top: 50),
        alignment: Alignment.topLeft,
        child: Image.asset('assets/gif/pokemon_pikachu.gif',
            height: 100, fit: BoxFit.fitHeight),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 80),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(AppStrings.APP_TITLE,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24))),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.pink),
                      onPressed: () {
                        Get.to(() => const PokemonFavListPage())?.then((value) {
                          if (Get.isSnackbarOpen) {
                            Get.closeAllSnackbars();
                          }
                          _pokemonListController.updateFav();
                        });
                      }))
            ]),
        const SizedBox(height: 20),
        Expanded(child: GetBuilder<PokemonListController>(builder: (_) {
          hasMore =
              _pokemonListController.pokemonList.value.nextRequestUrl != null;
          if (_pokemonListController.isError.value) {
            return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/connection_error.png',
                      width: 60, height: 60),
                  const SizedBox(height: 20),
                  const Text(AppStrings.API_ERROR)
                ]);
          } else if (_pokemonListController.isLoading.value && !hasMore) {
            return ViewUtils.loader();
          } else {
            var listSize =
                _pokemonListController.pokemonList.value.pokemon.length;
            return SizedBox(
              height: 200.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listSize + (hasMore ? 1 : 0),
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index < listSize) {
                    var pokemonItem =
                        _pokemonListController.pokemonList.value.pokemon[index];
                    return Card(
                        color: Colors.redAccent,
                        shadowColor: Colors.black,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 150),
                                () {
                              Get.to(() => const PokemonDetailPage(),
                                  arguments: pokemonItem.pokemonId);
                            });
                          },
                          splashColor: Colors.white,
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
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                ViewUtils
                                                    .firstLetterToUpperCase(
                                                        pokemonItem.name ?? ""),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                    const SizedBox(height: 10),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(75),
                                                  bottomLeft:
                                                      Radius.circular(75),
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  ViewUtils.getPokemonImageUrl(
                                                      pokemonItem.pokemonId),
                                              width: 100,
                                              fit: BoxFit.fitHeight,
                                              placeholder: (BuildContext
                                                          context,
                                                      String url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              strokeWidth:
                                                                  1.0)),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Icon(Icons.error,
                                                      size: 50)),
                                        ))
                                  ]),
                              GestureDetector(
                                onTap: () {
                                  if (pokemonItem.isFav) {
                                    _pokemonListController.removeFavPokemon(
                                        pokemonItem.pokemonId);
                                  } else {
                                    _pokemonListController
                                        .addFavPokemon(pokemonItem);
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(boxShadow: const [
                                      BoxShadow(color: Colors.black12)
                                    ], borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                        child: _pokemonListController
                                                .pokemonList
                                                .value
                                                .pokemon[index]
                                                .isFav
                                            ? const Icon(
                                                Icons.favorite_outlined,
                                                size: 17)
                                            : const Icon(Icons.favorite_border,
                                                size: 17)),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ));
                  } else {
                    return Padding(
                        padding: const EdgeInsets.all(30),
                        child: ViewUtils.loader());
                  }
                },
              ),
            );
          }
        })),
      ])
    ]));
  }
}
