class RelatedItem {
  //* create the items
  String title;
  String image;
  String type;
  int id;
  //* create an instance
  RelatedItem({
    required this.title,
    required this.image,
    required this.type,
    required this.id,
  });
  //* cast from json format
  factory RelatedItem.fromJson(Map<String, dynamic> json) =>
      RelatedItem(title: json["name"], image: json["url"], id: json["mal_id"],type: json["type"]);
}
