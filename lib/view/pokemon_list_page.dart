import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_strings.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 80),
      const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(AppStrings.APP_TITLE,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24)))),
      const SizedBox(height: 20),
      Expanded(
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Card(
                color: Colors.black12,
                child: Stack(children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: SvgPicture.network(
                                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/13$index.svg",
                                height: 100,
                                width: 100,
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(60.0),
                                        child:
                                            const CircularProgressIndicator()))),
                        Text("Ditto",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                  Transform.translate(
                      offset: const Offset(145, 10),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black12)],
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Image.asset("assets/images/pokemon_ball.png",
                                width: 30, height: 30, fit: BoxFit.cover)),
                      ))
                ]));
          },
        ),
      )
    ]));
  }
}
