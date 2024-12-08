import 'package:flutter/material.dart';

//* section button will change ui when active
Widget sectionButton(
    {required sectionIndex,
    required activeIndex,
    required String sectionName,
    required VoidCallback refreshFunction}) {
  //* create a bool to check with
  bool isActive = sectionIndex == activeIndex;
  return Expanded(
    child: GestureDetector(
      onTap: () {
        refreshFunction();
      },
      child: Container(
        alignment: Alignment.center,
        // some space !!
        padding: const EdgeInsets.all(8),
        //* the active section will have it's UI edited and glowing
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color:
                        isActive ? Colors.indigo : Colors.grey.withOpacity(.9),
                    width: isActive ? 6 : 2))),

        //* the section name
        child: Text(
          sectionName,
          style: TextStyle(
              fontFamily: "Quick",
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 20,
              color: isActive ? Colors.indigo : Colors.grey.withOpacity(.9)),
        ),
      ),
    ),
  );
}
