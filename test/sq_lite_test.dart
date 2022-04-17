// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_base/model/pokemon_favorite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'sq_lite_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  const String tablePokemon = 'pokemon';

  Future insertFavPokemon(
      MockDatabase db, PokemonFavorite pokemonFavorite) async {
    try {
      print("insertFavPokemon Success");
      return await db.insert(tablePokemon, pokemonFavorite.toMap());
    } catch (e) {
      print("insertFavPokemon Failed");
      debugPrint("$e");
    }
    return 0;
  }

  test('returns an Map if the http call completes successfully', () async {
    final db = MockDatabase();

    // Use Mockito to return a successful response when it calls the
    // provided http.Client.
    var pokemonFavItem = PokemonFavorite(1, "bulbasaur", "", "");
    when(db.insert(tablePokemon, pokemonFavItem.toMap())).thenAnswer((_) async {
      return 1;
    });

    expect(await insertFavPokemon(db, pokemonFavItem), isA<int>());
  });
}
