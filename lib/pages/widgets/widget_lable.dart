import 'package:flutter/material.dart';

//* a simple text with a label on top of it
Widget widgetLabel({required String title, required String value}) {
  // use .rich to create several texts with each unique style
  return Text.rich(
    textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: "Quick",
        fontWeight: FontWeight.bold,
      ),
      TextSpan(children: [
        // the label 
        TextSpan(text: "$title\n",
        style: const TextStyle(
          fontSize: 21
        )
        ), 
        // the value
        TextSpan(text: value,
        style: const TextStyle(
          fontWeight:FontWeight.bold,
          color: Colors.indigo,
          fontSize: 30
        )
        )]));
}
