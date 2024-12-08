import 'package:animeate/Shared/place_Holders.dart';

// check if an achievement is complete
void achievementWatcher(String achievementKey) {
  if (!achievementKeyList.contains(achievementKey)) {
    achievementKeyList.add(achievementKey);
  }
}

void watchCaseAchievement(Map<String, dynamic> genres) {
  if (genres.keys.contains("Hentai")) {
    achievementWatcher("Hentai...");
  } else if (genres.values.toList().length >= 100) {
    achievementWatcher("A weeb");
  } else if (genres["Romance"] != null && genres["Romance"] >= 50) {
    achievementWatcher("Need Love?");
  }
}
