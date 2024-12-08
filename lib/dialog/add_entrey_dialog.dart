import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Services/categories_services.dart';
import 'package:flutter/material.dart';

void showListDialog(BuildContext context, List<CategoryItem> items,
    AnimeItem anime, VoidCallback refreshing) {
  List<bool> checkedItems = checkIfItemExist(anime: anime);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog.adaptive(
          title: const Text(
            'Add it to',
            style: TextStyle(
                fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 25),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Text(
                    items[index].name,
                    style: const TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  value: checkedItems[index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedItems[index] = value ?? false;
                    });
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              onPressed: () {
                // Do something with the checked items
                handleChanges(anime: anime, states: checkedItems);
                refreshing();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}
