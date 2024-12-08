import 'package:animeate/Models/anime_item.dart';

class CategoryItem {
  //* create the properties
  String name;
  List<dynamic> items;

  //* create the instance
  CategoryItem({
    required this.name,
    required this.items,
  });

  //* cast the item to json format
  Map<String, dynamic> toJson() => {
        "name": name,
        "items": items.map((elem) => elem.toJson()).toList(),
      };

  //* cast the json format into Category
  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
      name: json["name"],
      items: json["items"].map((elem) => AnimeItem.fromJson(elem)).toList());

  //* get total entries in a category
  int getTotalItems() => items.length;
}
