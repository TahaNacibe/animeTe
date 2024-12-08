import 'package:flutter/material.dart';

Widget sideBarItem(String title, IconData icon, Color color, int currentIndex, int index, Function(int) onTap) {
  return InkWell(
    onTap: () => onTap(index),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: index == currentIndex
              ? color.withOpacity(.2)
              : Colors.transparent),
      child: Column(
        children: [Icon(icon), Text(title)],
      ),
    ),
  );
}
