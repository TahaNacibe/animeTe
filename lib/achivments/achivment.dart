class Achievement {
  //  set properties
  String name;
  String desc;
  int rarity;
  bool isObtained;

  // set instance
  Achievement({
    required this.name,
    required this.desc,
    required this.rarity,
    this.isObtained = false,
  });

  // cast to json format
  Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
        "rarity": rarity,
        "isObtained": isObtained,
      };

  // cast back into object
  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
      name: json["name"], desc: json["desc"], rarity: json["rarity"]);
}
