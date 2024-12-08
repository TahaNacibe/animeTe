import 'dart:ui';
import 'package:animeate/Api/jikan_api.dart';
import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/pages/Android/screens/anime_details_screen.dart';
import 'package:animeate/pages/widgets/more_item.dart';
import 'package:flutter/material.dart';

//* Convert moreLikePage into a StatefulWidget
class MoreLikePage extends StatefulWidget {
  final VoidCallback showItem;
  final String animeId;

  const MoreLikePage(
      {super.key, required this.showItem, required this.animeId});

  @override
  State<MoreLikePage> createState() => _MoreLikePageState();
}

class _MoreLikePageState extends State<MoreLikePage> {
  //* vars
  List<dynamic> items = [];
  //* functions
  void onClickOnItem({required AnimeItem value}) {
    if (value.title != "404") {
      if (isThePlatformWindows()) {
        animeDetailPlaceHolder = value;
        widget.showItem();
      } else {
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => AnimeDetailsScreen(anime: value)));
      }
    }
  }

  @override
  void initState() {
    getAnimeRecommendations(widget.animeId, context, currentUserSettings.sfw)
        .then((list) {
      items = list;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return SizedBox(
        height: 250,
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: itemsBuilder()),
      );
    } else {
      return errorWidget();
    }
  }

//* list builder for items
  Widget itemsBuilder() {
    return ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 220,
            width: 170,
            child: GestureDetector(
              onTap: () {
                getAnimeById(items[index].id.toString(), context).then((value) {
                  onClickOnItem(value: value);
                });
              },
              child: additionalItems(
                title: items[index].title,
                url: items[index].imageUrl,
                context: context,
                clearView: true,
                padding: 8,
              ),
            ),
          );
        });
  }

//* error case widget
  Widget errorWidget() {
    return const Text(
      "Nothing here to show...\n(*u*!)",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
