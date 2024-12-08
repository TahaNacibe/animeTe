import 'package:flutter/material.dart';

Widget settingItems(
    {required String name,
    required IconData icon,
    String sub = "",
    Widget rightHand = const SizedBox.shrink()}) {
  return Builder(builder: (context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(2, 0))
            ]),
        child: ListTile(
          subtitle: sub == ""
              ? null
              : Text(
                  sub,
                  style: const TextStyle(
                      fontFamily: "Quick",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
          leading: Icon(
            icon,
            size: 30,
          ),
          title: Text(
            name,
            style: const TextStyle(
                fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: rightHand,
        ),
      ),
    );
  });
}
