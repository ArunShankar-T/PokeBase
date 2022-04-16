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
    int pokemonId = Get.arguments;
    var _pokemonDetailController = Get.find<PokemonDetailController>();
    _pokemonDetailController.fetchPokemonDetails(pokemonId);
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                        color: Colors.yellow.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(boxShadow: const [
                                      BoxShadow(color: Colors.black12)
                                    ], borderRadius: BorderRadius.circular(50)),
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Icon(Icons.arrow_back,
                                        size: 30, color: Colors.white))),
                            Container(
                                alignment: Alignment.topCenter,
                                margin: const EdgeInsets.only(top: 8),
                                child: Obx(() {
                                  return Text(
                                      ViewUtils.firstLetterToUpperCase(
                                          _pokemonDetailController
                                                  .pokemonDetails.value.name ??
                                              ""),
                                      style: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center);
                                }))
                          ]),
                          Center(
                              child: CachedNetworkImage(
                                  imageUrl:
                                      ViewUtils.getPokemonImageUrl(pokemonId),
                                  height: 200,
                                  fit: BoxFit.fitHeight,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 1.0)),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, size: 50))),
                          Obx(() {
                            var _pokemonDetail =
                                _pokemonDetailController.pokemonDetails.value;
                            return (_pokemonDetailController.isError.value ||
                                    _pokemonDetailController.isLoading.value)
                                ? Container()
                                : Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.black12.withOpacity(0.4),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: 6.0)
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    width: double.infinity,
                                    height: 90,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                _getDetailContainer(AppStrings
                                                        .POKEMON_HEIGHT +
                                                    "${(_pokemonDetail.height ?? 0) / 10} m"),
                                                _getDetailContainer(AppStrings
                                                        .POKEMON_WEIGHT +
                                                    "${(_pokemonDetail.weight ?? 0) / 10.toDouble()} kg"),
                                              ]),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: _getPokemonTypes())
                                        ]));
                          })
                        ]))),
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
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center)
                      ]);
                } else if (_pokemonDetailController.isLoading.value) {
                  return ViewUtils.loader();
                } else {
                  return SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [_buildAbilities(), _buildStats()]));
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _getDetailContainer(String info) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white38, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Text(ViewUtils.firstLetterToUpperCase(info),
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center)));
  }

  Widget _buildChipWidget(String abilityName, Color bgColor, Color labelColor,
      {String? avatarString, Color? avatarBgColor}) {
    return Chip(
        backgroundColor: bgColor,
        label: Text(ViewUtils.firstLetterToUpperCase(abilityName),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: labelColor, fontSize: 15)),
        avatar: avatarString != null
            ? CircleAvatar(
                backgroundColor: avatarBgColor,
                child: Text(avatarString.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)))
            : null);
  }

  List<Widget> _getPokemonTypes() {
    var _controller = Get.find<PokemonDetailController>();
    var types = _controller.pokemonDetails.value.types;
    List<Widget> typeWidget = List.empty(growable: true);
    types?.forEach((element) {
      if (element.type?.name != null) {
        typeWidget.add(_getDetailContainer(element.type?.name ?? ""));
      }
    });
    typeWidget.addIf(typeWidget.isEmpty, Container());
    return typeWidget;
  }

  Widget _buildAbilities() {
    var _controller = Get.find<PokemonDetailController>();
    var abilities = _controller.pokemonDetails.value.abilities;
    List<Widget> abilityWidget = List.empty(growable: true);
    abilities?.forEach((element) {
      if (element.ability?.name != null) {
        abilityWidget.add(_buildChipWidget(
            element.ability?.name ?? "", Colors.blueGrey, Colors.white));
      }
    });
    return abilityWidget.isEmpty
        ? Container()
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppStrings.POKEMON_ABILITY,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueGrey.shade300)),
              const SizedBox(height: 10),
              Wrap(spacing: 10, children: abilityWidget)
            ]));
  }

  Widget _buildStats() {
    var _controller = Get.find<PokemonDetailController>();
    var stats = _controller.pokemonDetails.value.stats;
    List<Widget> statsWidget = List.empty(growable: true);
    stats?.forEach((element) {
      if (element.stat != null &&
          element.stat?.name != null &&
          element.baseStat != null) {
        statsWidget.add(_buildChipWidget(
            element.stat?.name ?? "", Colors.brown, Colors.white,
            avatarString: (element.baseStat ?? 0).toString(),
            avatarBgColor: Colors.black));
      }
    });
    return statsWidget.isEmpty
        ? Container()
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.brown.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppStrings.POKEMON_STATS,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.brown.shade300)),
              const SizedBox(height: 10),
              Wrap(spacing: 10, children: statsWidget)
            ]));
  }
}
