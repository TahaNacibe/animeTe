import 'dart:convert';
import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Models/settings_item.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:animeate/keys/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* save the categories list into the storage
Future<void> saveCategoriesListToStorage(List<CategoryItem> userList) async {
  // create the shared preferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // switch to less complicated format
  List<Map<String, dynamic>> jsonData =
      userList.map((elem) => elem.toJson()).toList();
  // cast into a simpler format
  String jsonString = jsonEncode(jsonData);
  // write the data to the storage
  prefs.setString(categories, jsonString);
}

//* read and load from the storage
Future<List<CategoryItem>> loadCategoryList(BuildContext context) async {
  // create a shared preferences instant
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // load the data from storage
  String? jsonString = prefs.getString(categories);
  // check if the data exist
  if (jsonString != null) {
    try {
      // if exist move back into normal data
      List<dynamic> jsonData = jsonDecode(jsonString);
      List<CategoryItem> categoriesList =
          jsonData.map((elem) => CategoryItem.fromJson(elem)).toList();
      // return the list
      return categoriesList;
    } catch (e) {
      showFastSnackBar(
          context, "Failed To load the user Data", Colors.orange, Icons.info);
      return [];
    }
  } else {
    // in case no data was found
    return [];
  }
}

//* delete all data (just in case (*-*!))
Future<bool> deleteAllData(BuildContext context) async {
  // create a shared preferences instant
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // delete all from the storage
  bool result = await prefs.clear();
  if (result) {
    // if done clear the last ones on the list
    userCategoriesList
        .clear(); // Clear your in-memory list after clearing storage
    showFastSnackBar(context, "All Data Were wiped", Colors.indigo, Icons.done);
    return true;
  } else {
    showFastSnackBar(
        context, "Failed To Delete data", Colors.orange, Icons.info);
    return false;
  }
}

//* save the settings
Future<void> saveSettingsToStorage(SettingsItem setting) async {
  // create the shared preferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // switch to less complicated format
  Map<String, dynamic> jsonData = setting.toJson();
  // cast into a simpler format
  String jsonString = jsonEncode(jsonData);
  // write the data to the storage
  prefs.setString(settingKey, jsonString);
}

//* read the settings
Future<SettingsItem> loadSettingsFromStorage(BuildContext context) async {
  // create a shared preferences instant
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // load the data from storage
  String? jsonString = prefs.getString(settingKey);
  // check if the data exist
  if (jsonString != null) {
    try {
      // if exist move back into normal data
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      SettingsItem setting = SettingsItem.fromJson(jsonData);
      // return
      return setting;
    } catch (e) {
      showFastSnackBar(
          context, "Failed To Load Settings", Colors.orange, Icons.info);
      return SettingsItem(
          gridCount: 3, achievements: [], clearCover: false, showNames: true);
    }
  } else {
    // in case no data was found
    return SettingsItem(
        gridCount: 3, achievements: [], clearCover: false, showNames: true);
  }
}
