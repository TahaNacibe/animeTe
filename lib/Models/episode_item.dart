class EpisodeItem {
  //* create the properties
  String url;
  String title;
  String duration;
  String synopsis;
  bool recap;
  bool filler;

  //* create instance
  EpisodeItem(
      {required this.url,
      required this.title,
      required this.duration,
      required this.recap,
      required this.synopsis,
      required this.filler});

  //* toJson formate
  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "duration": duration,
        "recap": recap,
        "synopsis":synopsis,
        "filler": filler
      };

  //* fromJson Formate
  factory EpisodeItem.fromJson(Map<String, dynamic> json) => EpisodeItem(
      url: json["url"],
      title: json["title"],
      duration: json["duration"].toString(),
      recap: json["recap"],
      synopsis: json["synopsis"] ?? "N/A",
      filler: json["filler"]);
}
