import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/pages/Android/screens/anime_details_screen.dart';
import 'package:flutter/material.dart';

//* the search result item widget
Widget searchItem(
    {required AnimeItem anime,
    required BuildContext context,
    required Function(AnimeItem) onAnimeSelected}) {
  return GestureDetector(
    onTap: () {
      // Existing navigation logic for Android
      if (!isThePlatformWindows()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnimeDetailsScreen(
                      anime: anime,
                    )));
      } else {
        // Call the new callback
        onAnimeSelected(anime);
      }
    },
    child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
              // set the anime cover as a bg
              image: DecorationImage(
                  image: NetworkImage(anime.bigImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10)),
        ),
        // name tag section
        Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(.8)],
                stops: const [0.4, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              anime.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
        )
      ],
    ),
  );
}
