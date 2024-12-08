import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Models/catagorie.dart';
import 'package:animeate/Shared/place_Holders.dart';

//* get total entries in all library
int getTotalAnime() {
  // place holder for the result
  int result = 0;
  for (CategoryItem cat in userCategoriesList) {
    // loop and add the length each time
    result = cat.getTotalItems();
  }
  // return result
  return result;
}

//* get most followed genres (rank what the user have based on it's repeated appearance)
Map<String, dynamic> getTopGenresForYou() {
  //place holder item
  Map<String, dynamic> genresWatchRecord = {};
  // loop through categories
  for (CategoryItem cat in userCategoriesList) {
    // loop through anime lists
    for (AnimeItem anime in cat.items) {
      // loop through each anime genres
      for (String genre in anime.genres) {
        // if genre is already there add one to the count
        if (genresWatchRecord.keys.contains(genre)) {
          genresWatchRecord[genre] += 1;
          // if genre is not there set it and give it value of 0
        } else {
          genresWatchRecord[genre] = 1;
        }
      }
    }
  }
  // return the result
  return genresWatchRecord;
}

//* get total episodes in the library
int getTotalEpisodes() {
  // place holder
  int result = 0;
  // loop through the categories
  for (CategoryItem cat in userCategoriesList) {
    // loop through the anime list for each
    for (AnimeItem anime in cat.items) {
      result += anime.getEpisodes();
    }
  }
  // return the result
  return result;
}

//* get total libraries number
int getLibrariesCount() {
  return userCategoriesList.length;
}
