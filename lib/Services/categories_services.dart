import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Provider/shared_prefernces.dart';
import 'package:animeate/Shared/place_Holders.dart';
//* add new category into the user list

void addNewCategory(String name) {
  // add new item
  userCategoriesList.add(CategoryItem(name: name, items: []));
  // save the data to the storage after update
  saveCategoriesListToStorage(userCategoriesList);
}

//* edit existing Category from the user list
void editCategory(String name, int index) {
  // change the entry name
  userCategoriesList[index].name = name;
  // save the data to the storage after update
  saveCategoriesListToStorage(userCategoriesList);
}

//* delete item from the user list
void deleteCategory(int index) {
  // remove at that index (should be more memory efficient not sure though (^0^)/)
  userCategoriesList.removeAt(index);
  // save the data to the storage after update
  saveCategoriesListToStorage(userCategoriesList);
}

//* add item to the user List
void addNewItemToCategory(int index, AnimeItem anime) {
  // add new item to the list (that simple? then why a separate function?)
  userCategoriesList[index].items.add(anime);
  // save the data to the storage after update
  saveCategoriesListToStorage(userCategoriesList);
}

//* remove an item from a category
void removeItemFromCategory(int categoryIndex, AnimeItem anime) {
  // remove anime from a category
  userCategoriesList[categoryIndex].items.remove(anime);
  // save the data to the storage after update
  saveCategoriesListToStorage(userCategoriesList);
}

//* change the item category
void handleChanges({required AnimeItem anime, required List<bool> states}) {
  for (var i = 0; i < states.length; i++) {
    bool shouldBeInCategory = states[i];
    bool isInCategory = userCategoriesList[i].items.contains(anime);
    if (shouldBeInCategory && !isInCategory) {
      // Add the anime to the category if it should be there but isn't
      addNewItemToCategory(i, anime);
    } else if (!shouldBeInCategory && isInCategory) {
      // Remove the anime from the category if it shouldn't be there but is
      removeItemFromCategory(i, anime);
    }
  }

  // Save the data to storage after all updates
  saveCategoriesListToStorage(userCategoriesList);
}

//* check if the item exist in a category
List<bool> checkIfItemExist({required AnimeItem anime}) {
  List<bool> result =
      List<bool>.generate(userCategoriesList.length, (index) => false);
  for (int i = 0; i < userCategoriesList.length; i++) {
    if (userCategoriesList[i].items.any((item) => item.title == anime.title)) {
      result[i] = true;
    }
  }
  return result;
}

//* check if the entry is in any category
bool theEntryIsInCategory({required AnimeItem anime}) {
  List<bool> items = checkIfItemExist(anime: anime);
  if (items.contains(true)) {
    // return tru if at least it in one category
    return true;
  } else {
    // return false if no category are found
    return false;
  }
}
