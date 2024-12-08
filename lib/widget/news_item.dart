import 'package:animeate/Models/news_item.dart';
import 'package:flutter/material.dart';

//* create the news widget
Widget newsItemWidget(NewsItem news, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        SizedBox(
          height: 500,
          width: MediaQuery.sizeOf(context).width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FadeInImage.assetNetwork(
              placeholder:
                  'assets/images/placeholder.png', // Create a placeholder image
              image: news.image,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: const Center(
                    child: Text(
                      "(*~*!)",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          // height: 100,
          decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(15)),
              color: Theme.of(context).cardColor.withOpacity(.9)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text.rich(
                  style: const TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                  TextSpan(children: [
                    TextSpan(
                        text: news.author,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const TextSpan(text: "  >  "),
                    TextSpan(text: news.title)
                  ])),
              const Divider(),
              Text(
                news.excerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
