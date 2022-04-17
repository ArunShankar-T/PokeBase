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
import 'package:poke_base/model/pokemon_detail.dart';

import 'fetch_pokemon_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  Future fetchPokemonDetail(http.Client client) async {
    final response =
        await client.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/1/"));

    if (response.statusCode == 200) {
      print("fetchPokemonDetail Success");
      return PokemonDetails.fromJson(json.decode(response.body));
    } else {
      print("fetchPokemonDetail failed");
      throw Exception("Something went wrong while fetching pokemon");
    }
  }

  group('fetchPokemonDetail', () {
    test('returns an Map if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1/')))
          .thenAnswer((_) async => http.Response(
              '{"abilities":[{"ability":{"name":"overgrow","url":"https://pokeapi.co/api/v2/ability/65/"},"is_hidden":false,"slot":1}],"base_experience":64,"height":7,"id":1,"name":"bulbasaur","stats":[{"base_stat":45,"effort":0,"stat":{"name":"hp","url":"https://pokeapi.co/api/v2/stat/1/"}}],"types":[{"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}],"weight":69}',
              200));

      expect(await fetchPokemonDetail(client), isA<PokemonDetails>());
    });

    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1/')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(await fetchPokemonDetail(client), throwsException);
    });
  });
}
