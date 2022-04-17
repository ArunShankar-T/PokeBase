import 'package:flutter/foundation.dart';
import 'package:poke_base/model/pokemon_favorite.dart';
import 'package:sqflite/sqflite.dart';

const String tablePokemon = 'pokemon';
const String columnId = 'id';
const String columnName = 'name';
const String columnIMageBase64 = 'image_base64';

class SQLiteHelper {
  Database? _database;
  static SQLiteHelper? _sqLiteHelper;

  /// Returns the SQLiteHelper Instance as Singleton.
  static getSQLiteHelper() {
    _sqLiteHelper ??= SQLiteHelper();
    return _sqLiteHelper;
  }

  /// Returns the database Instance as Singleton.
  Future<Database?> getDb() async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  /// Returns the database instance.
  Future<Database?> initializeDatabase() async {
    try {
      var dir = await getDatabasesPath();
      var path = dir + "pokemon.db";
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE $tablePokemon ("
              "$columnId INTEGER PRIMARY KEY,"
              "$columnName TEXT,"
              "$columnIMageBase64 TEXT"
              ")");
        },
      );
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  /// To insert a record into the table [tablePokemon], takes [PokemonFavorite] as params.
  /// Returns the id of the last inserted row.
  Future<int> insertFavPokemon(PokemonFavorite pokemonFavorite) async {
    try {
      var db = await getDb();
      return await db?.insert(tablePokemon, pokemonFavorite.toMap()) ?? 0;
    } catch (e) {
      debugPrint("$e");
    }
    return 0;
  }

  /// To get all the record from [tablePokemon].
  Future<List<PokemonFavorite>> getFavPokemon() async {
    List<PokemonFavorite> _pokemonFavorite = [];
    try {
      var db = await getDb();
      var result = await db?.query(tablePokemon);
      result?.forEach((element) {
        var pokemonFavorite = PokemonFavorite.fromMap(element);
        _pokemonFavorite.add(pokemonFavorite);
      });
    } catch (e) {
      debugPrint("$e");
    }
    return _pokemonFavorite;
  }

  /// To get all the [columnId] from [tablePokemon].
  Future<List<int>> getFavPokemonIds() async {
    List<int> _pokemonFavoriteIds = [];
    try {
      var db = await getDb();
      var result = await db?.query(tablePokemon, columns: [columnId]);
      var idMap = (result as List<Map>);
      for (var element in idMap) {
        _pokemonFavoriteIds.add(element.values.first as int);
      }
    } catch (e) {
      debugPrint("$e");
    }
    return _pokemonFavoriteIds;
  }

  /// To delete the records from [tablePokemon] having where [columnId] is [id].
  /// Returns the number of rows affected.
  Future<int> deleteFavPokemon(int id) async {
    try {
      var db = await getDb();
      return await db
              ?.delete(tablePokemon, where: '$columnId = ?', whereArgs: [id]) ??
          0;
    } catch (e) {
      debugPrint("$e");
    }
    return 0;
  }
}
