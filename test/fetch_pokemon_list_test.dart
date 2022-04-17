// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_base/model/pokemon_list.dart';

import 'fetch_pokemon_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  Future fetchPokemon(http.Client client) async {
    final response = await client
        .get(Uri.parse("https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"));

    if (response.statusCode == 200) {
      print("fetchPokemon Success");
      return PokemonList.fromJson(json.decode(response.body));
    } else {
      print("fetchPokemon failed");
      throw Exception('exception occured!!!!!!');
    }
  }

  group('fetchPokemon', () {
    test('returns an Map if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(
              Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=0&limit=20')))
          .thenAnswer((_) async {
        return http.Response(
            '{"count":1126,"next":"https://pokeapi.co/api/v2/pokemon?offset=20&limit=20","previous":null,"results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"},{"name":"ivysaur","url":"https://pokeapi.co/api/v2/pokemon/2/"}]}',
            200);
      });

      expect(await fetchPokemon(client), isA<PokemonList>());
    });

    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(
              Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=0&limit=20')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(await fetchPokemon(client), throwsException);
    });
  });
}
