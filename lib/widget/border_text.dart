import 'package:flutter/material.dart';

//* a small text with budge like border
Widget typeBudget(String name) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: 1.5),
        borderRadius: BorderRadius.circular(8)),
    // creating some space
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    // text body
    child: Text(
      name,
      style: const TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
          fontSize: 15),
    ),
  );
}
