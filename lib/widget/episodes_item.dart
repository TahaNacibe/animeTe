import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//* var for hight and width
double epHight = 150;
double epWidth = 200;
//* a small episode box show the cover name of anime and episode number
Widget episodeWidget({required int index, required String url}) {
  index += 1;
  return Builder(builder: (context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: epHight,
            width: epWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(url), fit: BoxFit.cover)),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            alignment: Alignment.bottomLeft,
            height: epHight,
            width: epWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Text(
              "Episode $index",
              style: const TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 21),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).cardColor.withOpacity(.6)),
            child: const Icon(
              Icons.play_circle,
              size: 45,
            ),
          )
        ],
      ),
    );
  });
}
