import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/utils/app_strings.dart';

class ViewUtils {
  static getPokemonImageUrl(int pokemonId) {
    return AppStrings.POKEMON_IMAGE_URL
        .replaceAll(AppStrings.POKEMON_ID_PLACEHOLDER, pokemonId.toString());
  }

  static Widget loader() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  static stringToBytes(String imageBase64) {
    return const Base64Codec().decode(imageBase64);
  }

  static firstLetterToUpperCase(String text) {
    return text.isNotEmpty
        ? text.substring(0, 1).toUpperCase() + text.substring(1, text.length)
        : "";
  }

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
