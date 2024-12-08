class RecommendationsItem {
  //* properties create
  String title;
  String imageUrl;
  int id;
  //* create an instant
  RecommendationsItem({
    required this.id,
    required this.imageUrl,
    required this.title,
  });
  //* from json
  factory RecommendationsItem.fromJson(Map<String, dynamic> json) =>
      RecommendationsItem(
          id: json["mal_id"],
          imageUrl: json["images"]["jpg"]["large_image_url"],
          title: json["title"]);
}
