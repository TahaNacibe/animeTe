import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget additionalItems({
  required String title,
  required String url,
  required BuildContext context,
  required double padding,
  bool showName = true,
  bool clearView = false,
}) {
  return StatefulBuilder(builder: (context, setState) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Stack(
        children: [
          // Text display
          Container(
            alignment: Alignment.center,
            child: const Text(
              "(0~0!)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          // Background image
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Title overlay
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  clearView
                      ? Colors.black.withOpacity(0.7)
                      : Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: showName
                ? Text(
                    title,
                    maxLines: 3,
                    style: const TextStyle(
                      fontFamily: "Quick",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          // HD label
          if (clearView) hdTag()
        ],
      ),
    );
  });
}

//* hd tag
Widget hdTag() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.indigo,
        ),
        child: const Text(
          "HD",
          style: TextStyle(
            fontFamily: "Quick",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
