import 'package:animeate/widget/text_with_lable.dart';
import 'package:flutter/material.dart';

//* just a bar holding a bunch of labeled text
Widget animeDetailsBar(
    {required String studio, required String source, required String rank}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 3),
        child: Divider(
          color: Colors.grey.withOpacity(.5),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: textWithLabel(title: "Studio", value: setDefault(studio))),
          Expanded(child: textWithLabel(title: "Source", value: setDefault(source))),
          Expanded(child: textWithLabel(title: "Ranked", value: "#${setDefault(rank)}")),
        ],
      ),
    ],
  );
}

 //* set default
  String setDefault(String value) {
    return value == "null" ? "N/A" : value;
  }