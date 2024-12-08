import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Models/episode_item.dart';
import 'package:animeate/Models/settings_item.dart';
import 'package:flutter/material.dart';

AnimeItem animeItemPlaceHolder = AnimeItem(
    title: '404',
    smallImage: '',
    url: "",
    bigImage: '',
    source: '',
    airYear: '',
    rating: '',
    synopsis: '',
    studio: '',
    genres: [],
    isAiring: false,
    episodes: "0",
    score: "0",
    rank: "",
    animeId: "0");

EpisodeItem episodeItem = EpisodeItem(
    url: "url",
    title: "Empty",
    duration: "0.0",
    recap: false,
    filler: false,
    synopsis: "");

InputBorder borderSetting = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.withOpacity(.6), width: 1.5),
    borderRadius: BorderRadius.circular(15));

//* shared from the loading screen
//? categories list
List<CategoryItem> userCategoriesList = [];
List<String> achievementKeyList = [];
SettingsItem currentUserSettings = SettingsItem(
    gridCount: 3, achievements: [], clearCover: false, showNames: true);
AnimeItem animeDetailPlaceHolder = AnimeItem(
    title: 'Empty',
    url: "",
    smallImage: '',
    bigImage: '',
    source: '',
    airYear: '',
    rating: '',
    synopsis: '',
    studio: '',
    genres: [],
    isAiring: false,
    episodes: "0",
    score: "0",
    rank: "",
    animeId: "0");
