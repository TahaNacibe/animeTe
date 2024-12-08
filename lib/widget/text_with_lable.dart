import 'package:flutter/material.dart';

//* a simple text with a label on top of it
Widget textWithLabel({required String title, required String value}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 21,
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        value,
        style: const TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
