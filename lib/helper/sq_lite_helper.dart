import 'package:poke_base/model/pokemon_favorite.dart';
import 'package:sqflite/sqflite.dart';

const String tablePokemon = 'pokemon';
const String columnId = 'id';
const String columnName = 'name';
const String columnIMageBase64 = 'image_base64';

class SQLiteHelper {
  Database? _database;
  static SQLiteHelper? _sqLiteHelper;

  static getSQLiteHelper() {
    _sqLiteHelper ??= SQLiteHelper();
    return _sqLiteHelper;
  }

  Future<Database?> getDb() async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

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
      print(e);
    }
    return null;
  }

  Future<int> insertFavPokemon(PokemonFavorite pokemonFavorite) async {
    try {
      var db = await getDb();
      return await db?.insert(tablePokemon, pokemonFavorite.toMap()) ?? 0;
    } catch (e) {
      print(e);
    }
    return 0;
  }

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
      print(e);
    }
    return _pokemonFavorite;
  }

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
      print(e);
    }
    return _pokemonFavoriteIds;
  }

  Future<int> deleteFavPokemon(int id) async {
    try {
      var db = await getDb();
      return await db
              ?.delete(tablePokemon, where: '$columnId = ?', whereArgs: [id]) ??
          0;
    } catch (e) {
      print(e);
    }
    return 0;
  }
}
