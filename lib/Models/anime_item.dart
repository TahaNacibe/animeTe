class AnimeItem {
  //* properties
  String title;
  String url;
  String smallImage;
  String bigImage;
  String source;
  String rating;
  String synopsis;
  String studio;
  List<dynamic> genres;
  String score;
  bool isAiring;
  String airYear;
  String episodes;
  String animeId;
  String rank;

  //* create instance
  AnimeItem({
    required this.title,
    required this.smallImage,
    required this.bigImage,
    required this.url,
    required this.source,
    required this.airYear,
    required this.rating,
    required this.synopsis,
    required this.studio,
    required this.genres,
    required this.isAiring,
    required this.episodes,
    required this.score,
    required this.rank,
    required this.animeId,
  });

  //* to json setting
  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "images": {
          "jpg": {
            "small_image_url": smallImage,
            "large_image_url": bigImage,
          }
        },
        "source": source,
        "year": int.tryParse(airYear),
        "rating": rating,
        "synopsis": synopsis,
        "studios": [
          {"name": studio}
        ],
        "genres": genres.map((genre) => {"name": genre}).toList(),
        "airing": isAiring,
        "episodes": int.tryParse(episodes),
        "score": double.tryParse(score),
        "rank": int.tryParse(rank),
        "mal_id": int.tryParse(animeId)
      };

  //* from json
  factory AnimeItem.fromJson(Map<String, dynamic> json) => AnimeItem(
      title: json["title"],
      url: json["url"] ?? "N/A",
      smallImage: json["images"]["jpg"]["small_image_url"] ?? "N/A",
      bigImage: json["images"]["jpg"]["large_image_url"] ?? "N/A",
      source: json["source"] ?? "N/A",
      airYear: json["year"].toString(),
      rating: json["rating"].toString(),
      synopsis: json["synopsis"] ?? "N/A",
      studio: json["studios"].map((e) => e["name"]).join(","),
      genres: json["genres"].map((e) => e["name"]).toList(),
      isAiring: json["airing"] ?? false,
      episodes: json["episodes"].toString(),
      score: json["score"].toString(),
      rank: json["rank"].toString(),
      animeId: (json["mal_id"]).toString());

  //* get total anime episodes
  int getEpisodes() => int.tryParse(episodes) ?? 0;
}
