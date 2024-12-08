import 'package:flutter/material.dart';

//* fast to use snack bar
void showFastSnackBar(
    BuildContext context, String text, Color borderColor, IconData icon) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: borderColor,
          ),
          Text(
            "  $text",
            style: const TextStyle(
                fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}
