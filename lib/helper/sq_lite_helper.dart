import 'package:poke_base/model/pokemon_favorite.dart';
import 'package:sqflite/sqflite.dart';

const String tablePokemon = 'pokemon';
const String columnId = 'id';
const String columnName = 'name';
const String columnIMageBase64 = 'image_base64';

class SQLiteHelper {
  static Database? _database;
  static SQLiteHelper? _sqLiteHelper;

  getSQLiteHelper() {
    _sqLiteHelper ??= SQLiteHelper();
    return _sqLiteHelper;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "pokemon.db";

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tablePokemon ( 
          $columnId integer primary key, 
          $columnName text not null,
          $columnIMageBase64 text not null''');
      },
    );
  }

  void insertFavPokemon(PokemonFavorite pokemonFavorite) async {
    var db = await database;
    var result = await db?.insert(tablePokemon, pokemonFavorite.toMap());
    print('sqlite insert result : $result');
  }

  Future<List<PokemonFavorite>> getFavPokemon() async {
    List<PokemonFavorite> _pokemonFavorite = [];

    var db = await database;
    var result = await db?.query(tablePokemon);
    result?.forEach((element) {
      var pokemonFavorite = PokemonFavorite.fromMap(element);
      _pokemonFavorite.add(pokemonFavorite);
    });

    return _pokemonFavorite;
  }

  void deleteFavPokemon(int id) async {
    var db = await database;
    var result =
        await db?.delete(tablePokemon, where: '$columnId = ?', whereArgs: [id]);
    print('sqlite delete result : $result');
  }
}
