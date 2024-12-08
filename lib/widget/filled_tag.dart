  import 'package:flutter/material.dart';
//* widget for type badge
Widget typeBudge(String name){
    return Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: 1.5),
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(8)),
    // creating some space
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    // text body
    child: Text(
      name,
      style: const TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18),
    ),
  );
  }