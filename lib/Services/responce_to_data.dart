import 'dart:convert';
import 'package:http/http.dart' as http;

//* convert the response to data following the model structure
Map<String, dynamic> responseToData(http.Response response) {
  // decode the response body into a map
  Map<String, dynamic> responseBody = jsonDecode(response.body);
  List<dynamic> dataList = responseBody["data"];

  // If the list is empty, return an empty list
  if (dataList.isEmpty) {
    return {"results": []};
  }

  // Process all items in the list
  List<Map<String, dynamic>> results = dataList.map((data) {
    return {
      "title": data["title"] ?? "N/A",
      "smallImage": data["images"]["jpg"]["small_image_url"] ?? "N/A",
      "bigImage": data["images"]["jpg"]["large_image_url"] ?? "N/A",
      "source": data["source"] ?? "N/A",
      "airYear": data["year"] != null? data["year"].toString() : "N/A",
      "rating": data["rating"] != null? data["rating"].toString() : "N/A",
      "synopsis": data["synopsis"] ?? "N/A",
      "studio": data["studios"].isNotEmpty ? data["studios"][0]["name"] ?? "N/A" : "N/A",
      "trailer": data["trailer"]?["url"] ?? "N/A",
      "genres": (data["genres"] as List?)?.map((genre) => genre["name"] ?? "N/A").toList() ?? ["N/A"],
      "isAiring": data["status"] == "Finished Airing",
      "episodes": data["episodes"] != null? data["episodes"].toString() : "N/A",
      "score": data["score"] != null? data["score"].toString() : "N/A",
      "rank": data["rank"] != null? data["rank"].toString() : "N/A",
      "animeId": data["mal_id"] != null? data["mal_id"].toString() : "N/A"
    };
  }).toList();

  return {"results": results};
}
