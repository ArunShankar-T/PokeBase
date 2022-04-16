import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poke_base/utils/app_strings.dart';

class ViewUtils {
  static getPokemonImageUrl(int pokemonId) {
    return AppStrings.POKEMON_IMAGE_URL
        .replaceAll(AppStrings.POKEMON_ID_PLACEHOLDER, pokemonId.toString());
  }

  static Widget loader() {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  static stringToBytes(String imageBase64){
    return const Base64Codec().decode(imageBase64);
  }
}
