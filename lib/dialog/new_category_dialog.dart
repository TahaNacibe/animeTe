import 'package:animeate/Services/categories_services.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:flutter/material.dart';

//* show the dialog
void showAddCategoryDialog(
    {required BuildContext context,
    required VoidCallback addItem,
    String preText = "",
    int editCategoryIndex = 0}) {
  //* create the controller
  TextEditingController categoryController = TextEditingController();
  if (preText.isNotEmpty) {
    categoryController.text = preText;
  }
  showModalBottomSheet(
      isScrollControlled:
          true, // Ensures the bottom sheet resizes with keyboard
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // Adjusts for keyboard
          child: SingleChildScrollView(
            // Makes the content scrollable
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add a new Category',
                    style: TextStyle(
                        fontFamily: "Quick",
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: categoryController,
                    style: const TextStyle(
                      fontFamily: "Quick",
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter category name',
                      border: borderSetting,
                      enabledBorder: borderSetting,
                      focusedBorder: borderSetting,
                      errorBorder: borderSetting,
                      focusedErrorBorder: borderSetting,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          //* Add logic to save the category
                          if (categoryController.text.isNotEmpty) {
                            //* in case the user input something
                            // in case no pre text new item no edit
                            if (preText.isEmpty) {
                              addNewCategory(categoryController.text);
                            } else {
                              // the case edit
                              editCategory(
                                  categoryController.text, editCategoryIndex);
                            }
                            addItem();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
