class Pokemon {
  String? name;
  String? url;

  Pokemon({this.name, this.url});

  Pokemon.fromJson(Map<String, String> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, String?> toJson() {
    final Map<String, String?> data = Map<String, String?>();
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}