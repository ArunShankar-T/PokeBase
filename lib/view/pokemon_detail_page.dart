import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/controller/pokemon_detail_controller.dart';
import 'package:poke_base/utils/app_strings.dart';
import 'package:poke_base/utils/view_utils.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _pokemonDetailController = Get.put(PokemonDetailController());
    int pokemonId = Get.arguments;
    _pokemonDetailController.fetchPokemonDetails(pokemonId);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0)
                    ],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              child: const Icon(Icons.arrow_back,
                                  size: 30, color: Colors.white),
                            )),
                      ),
                      Center(
                          child: CachedNetworkImage(
                              imageUrl: ViewUtils.getPokemonImageUrl(pokemonId),
                              height: 300,
                              fit: BoxFit.fitHeight,
                              placeholder: (BuildContext context, String url) =>
                                  const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1.0)),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, size: 50))),
                      Text(
                          _pokemonDetailController.pokemonDetails.value.name ??
                              "",
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white),
                          textAlign: TextAlign.center)
                    ]),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_pokemonDetailController.isError.value) {
                  return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/connection_error.png',
                            width: 60, height: 60),
                        const SizedBox(height: 20),
                        const Text(AppStrings.API_ERROR,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center)
                      ]);
                } else if (_pokemonDetailController.isLoading.value) {
                  return ViewUtils.loader();
                } else {
                  return Container();
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
