import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poke_base/controller/network_controller.dart';
import 'package:poke_base/utils/app_strings.dart';
import 'package:poke_base/view/pokemon_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NetworkController());
    return GetMaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: const PokemonListPage());
  }
}
