import 'dart:convert';
import 'package:animeate/Models/episode_item.dart';
import 'package:animeate/Models/news_item.dart';
import 'package:animeate/Models/recomandations_item.dart';
import 'package:animeate/Models/related_item.dart';
import 'package:animeate/Services/responce_to_data.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:animeate/Models/anime_item.dart';

//* keys
const String apiEndPoint = "https://api.jikan.moe/v4";

//* Search the anime with a name, excluding NSFW content
Future<List<dynamic>> searchAnimeByName(
    String name, BuildContext context, bool isHnVisible) async {
  final http.Response response = await http
      .get(Uri.parse("$apiEndPoint/anime?q=$name&sfw=${!isHnVisible}"));
  print("$apiEndPoint/anime?q=$name&sfw=${!isHnVisible}");
  if (response.statusCode == 200) {
    // decode the response body into a map
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<dynamic> dataList = responseBody["data"];
    try {
      // print(dataList);
      return dataList.map((elem) => AnimeItem.fromJson(elem)).toList();
    } catch (e) {
      showFastSnackBar(
          context, "Error processing data", Colors.red, Icons.error);
      return [];
    }
  } else {
    showFastSnackBar(context, "Couldn't search. Status: ${response.statusCode}",
        Colors.orange, Icons.info);
    return [];
  }
}

//* get anime by Id
Future<AnimeItem> getAnimeById(String id, BuildContext context) async {
  final http.Response response =
      await http.get(Uri.parse("$apiEndPoint/anime/$id"));
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return AnimeItem.fromJson(data["data"]);
  } else {
    //? Handle the error cases one by one please
    showFastSnackBar(
        context, "Failed To Load Anime Data", Colors.orange, Icons.info);
    return animeItemPlaceHolder;
  }
}

//* get anime episodes
Future<List<dynamic>> getEpisodesById(int animeId, BuildContext context) async {
  // get the request result
  final http.Response response = await http
      .get(Uri.parse("https://api.jikan.moe/v4/anime/$animeId/episodes"));
  // proses response
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data["data"].map((elem) => EpisodeItem.fromJson(elem)).toList();
  } else {
    showFastSnackBar(
        context, "Failed To Load Episodes Data", Colors.orange, Icons.info);
    //? Handle the error cases one by one please
    return [];
  }
}

//* get a specific episode by id
Future<EpisodeItem> getSpecificEpisode(
    String animeId, int episodeId, BuildContext context) async {
  // request the data
  http.Response response = await http.get(
      Uri.parse("https://api.jikan.moe/v4/anime/$animeId/episodes/$episodeId"));
  // proses the respond
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return EpisodeItem.fromJson(data["data"]);
  } else {
    //? Handle the error cases one by one please
    showFastSnackBar(context, "Failed To Load The Episode $episodeId",
        Colors.orange, Icons.info);
    return episodeItem;
  }
}

//* get anime news by id for some reason
Future<List<dynamic>> getAnimeNewsById(int animeId) async {
  // request the data
  http.Response response =
      await http.get(Uri.parse("https://api.jikan.moe/v4/anime/$animeId/news"));
  // proses the respond
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data["data"].map((elem) => NewsItem.fromJson(elem)).toList();
  } else {
    //? Handle the error cases one by one please
    return [];
  }
}

//* get anime recommendations by id for some reason
Future<List<dynamic>> getAnimeRecommendations(
    String animeId, BuildContext context, bool isHnVisible) async {
  // request the data
  http.Response response = await http.get(Uri.parse(
      "https://api.jikan.moe/v4/anime/$animeId/recommendations?sfw=${!isHnVisible}"));
  // proses the respond
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data["data"]
        .map((elem) => RecommendationsItem.fromJson(elem["entry"]))
        .toList();
  } else {
    //? Handle the error cases one by one please
    showFastSnackBar(
        context, "Failed To Load Remanded Anime", Colors.orange, Icons.info);
    return [];
  }
}

Future<Map<String, List<RelatedItem>>> getAnimeRelations(
    String animeId, BuildContext context, bool isHnVisible) async {
  final response = await http.get(
      Uri.parse("$apiEndPoint/anime/$animeId/relations?sfw=${!isHnVisible}"));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    Map<String, List<RelatedItem>> relationsMap = {};

    for (var relationData in data["data"]) {
      String relation = relationData["relation"];
      List<RelatedItem> relatedItems = [];

      for (var item in relationData["entry"]) {
        RelatedItem relatedItem = RelatedItem.fromJson(item);
        if (item["type"] == "anime") {
          try {
            String imageUrl =
                await getAnimeImageById(item["mal_id"].toString());
            relatedItem.image = imageUrl;
          } catch (e) {
            // throw "Error from the api side ignore";
          }
        }
        relatedItems.add(relatedItem);
      }

      relationsMap[relation] = relatedItems;
    }
    relationsMap.remove("Adaptation");
    return relationsMap;
  } else {
    showFastSnackBar(context, "Failed To Load Data", Colors.orange, Icons.info);
    return {};
  }
}

// New function to get only the image URL from the anime details
Future<String> getAnimeImageById(String id) async {
  final http.Response response =
      await http.get(Uri.parse("$apiEndPoint/anime/$id"));
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data["data"]["images"]["jpg"]["image_url"] ?? "";
  } else {
    throw Exception("Failed to load anime image: ${response.statusCode}");
  }
}
