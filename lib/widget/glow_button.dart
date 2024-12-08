import 'package:flutter/material.dart';

//* glowing costume button
Widget glowingButton(
    {required String name,
    required Color color,
    required IconData icon,
    bool isFilled = true,
    required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // paddings
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // in case the button is filled other wise set a transparent color
          color: isFilled ? color : Colors.transparent,
          border: Border.all(color: color, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              icon,
              color: isFilled ? Colors.white : color,
            ),
          ),
          // title
          Text(
            name,
            style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                color: isFilled ? Colors.white : color,
                fontSize: 21),
          )
        ],
      ),
    ),
  );
}
