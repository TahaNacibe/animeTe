class NewsItem {
  //* set properties
  String title;
  String url;
  String author;
  String image;
  String excerpt;
  //* set instance
  NewsItem(
      {required this.title,
      required this.url,
      required this.author,
      required this.image,
      required this.excerpt});
  //* from json formate
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
        title: json["title"],
        url: json["url"],
        author: json["author_username"],
        image: json["images"]["jpg"]["image_url"] ?? "N/A",
        excerpt: json["excerpt"]);
  }
}
