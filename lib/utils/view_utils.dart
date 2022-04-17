import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/utils/app_strings.dart';

class ViewUtils {
  /// To build the image url of pokemon using [pokemonId].
  static getPokemonImageUrl(int pokemonId) {
    return AppStrings.pokemonImageUrl
        .replaceAll(AppStrings.pokemonIdPlaceholder, pokemonId.toString());
  }

  /// Returns a loader widget.
  static Widget loader() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  /// Make the first letter as UpperCase and Returns tha string [text].
  static firstLetterToUpperCase(String text) {
    return text.isNotEmpty
        ? text.substring(0, 1).toUpperCase() + text.substring(1, text.length)
        : "";
  }

  /// To build a Snackbar with no network connection message.
  static showNoNetworkMessage() {
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.snackbar("No Connection", "Please connect to internet",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          isDismissible: true);
    });
  }
}
