class Pokemon {
  String? name;
  String? url;

  Pokemon({this.name, this.url});

  int pokemonId = 0;

  Pokemon.fromJson(Map<String, dynamic> json) {
    try {
      name = json['name'];
      url = json['url'];
      pokemonId = int.parse(url?.split("/")[6] ?? "0");
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}