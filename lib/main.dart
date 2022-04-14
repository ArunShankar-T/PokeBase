import 'package:flutter/material.dart';
import 'package:poke_base/utils/app_strings.dart';
import 'package:poke_base/view/PokemonListPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppStrings.APP_TITLE,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: const PokemonListPage());
  }
}
