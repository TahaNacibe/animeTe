import 'dart:io';
import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Provider/shared_prefernces.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

//* create buckUp
/// Writes a map to a JSON file in a user-chosen folder
Future<void> createBackup(List<CategoryItem> data, BuildContext context) async {
  try {
    // Check and request storage permission
    if (!await Permission.storage.request().isGranted) {
      showFastSnackBar(context, "Permission Denied", Colors.red, Icons.error);
      return;
    }
    // Let user choose the directory
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      showFastSnackBar(
          context, "No Directory Selected", Colors.red, Icons.error);
      return;
    }
    // Create a file name with current timestamp
    String fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.at';
    File file = File('$selectedDirectory/$fileName');
    // switch to less complicated format
    List<Map<String, dynamic>> jsonData =
        data.map((elem) => elem.toJson()).toList();
    // Convert map to JSON string
    String jsonString = jsonEncode(jsonData);
    // Write to file
    await file.writeAsString(jsonString);
    showFastSnackBar(
        context, "BackUp Created Completed", Colors.indigo, Icons.done);
  } catch (e) {
    // error handling
    showFastSnackBar(context, "Error: $e", Colors.orange, Icons.info);
  }
}

//* load buckUp
/// Reads a JSON file chosen by the user and returns a map
Future<void> loadBackup(BuildContext context) async {
  try {
    // Check and request storage permission
    if (!await Permission.storage.request().isGranted) {
      showFastSnackBar(context, "Permission Denied", Colors.red, Icons.error);
      return;
    }
    // Let user choose the file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['at'],
    );
    if (result == null) {
      showFastSnackBar(context, "No File Selected", Colors.red, Icons.error);
      return;
    }
    // Read file contents
    File file = File(result.files.single.path!);
    String jsonString = await file.readAsString();
    // check if the data exist
    // if exist move back into normal data
    List<dynamic> jsonData = jsonDecode(jsonString);
    List<CategoryItem> categoriesList =
        jsonData.map((elem) => CategoryItem.fromJson(elem)).toList();
    // update the data
    userCategoriesList = categoriesList;
    saveCategoriesListToStorage(userCategoriesList);
    showFastSnackBar(context, "BackUp Loaded", Colors.indigo, Icons.done);
  } catch (e) {
    // error handling
    showFastSnackBar(context, "Error: $e", Colors.orange, Icons.info);
    userCategoriesList = [];
  }
}
