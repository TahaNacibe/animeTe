class SettingsItem {
  int gridCount;
  bool clearCover;
  bool showNames;
  bool sfw;
  bool activateSfw;
  List<dynamic> achievements;

  SettingsItem({
    required this.gridCount,
    required this.achievements,
    required this.clearCover,
    required this.showNames,
    this.sfw = false,
    this.activateSfw = false,
  });

  //* formate json
  Map<String, dynamic> toJson() => {
        "gridCount": gridCount,
        "achievements": achievements,
        "clearCover": clearCover,
        "showNames": showNames,
        "sfw": sfw,
        "activateSfw":activateSfw
      };

  //* format to object
  factory SettingsItem.fromJson(Map<String, dynamic> json) {
    return SettingsItem(
        gridCount: json["gridCount"],
        achievements: json["achievements"],
        clearCover: json["clearCover"],
        sfw: json["sfw"],
        activateSfw: json["activateSfw"],
        showNames: json["showNames"]);
  }
}
