import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/pages/Android/screens/anime_details_screen.dart';
import 'package:animeate/pages/Android/screens/library_screen.dart';
import 'package:animeate/pages/Android/screens/more_screen.dart';
import 'package:animeate/pages/Android/screens/news_screen.dart';
import 'package:animeate/pages/Android/screens/search_screen.dart';
import 'package:animeate/pages/Android/screens/statics_screen.dart';
import 'package:animeate/pages/widgets/sidebar_item.dart';
import 'package:flutter/material.dart';

class WindowsHome extends StatefulWidget {
  const WindowsHome({super.key});

  @override
  State<WindowsHome> createState() => _WindowsHomeState();
}

class _WindowsHomeState extends State<WindowsHome> {
  //* vars declaration
  List<Widget> pagesList = [
    const SearchScreen(),
    const NewsScreen(),
    const StaticsScreen(),
    const MoreScreen(),
  ];
  int _currentIndex = 0;
  bool showAnimeDetails = false;
  AnimeItem anime = animeDetailPlaceHolder;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      showAnimeDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              children: [
                sideBarItem("Search", Icons.search, Colors.orange, _currentIndex,
                    0, _onItemTapped),
                sideBarItem("Update", Icons.update, Colors.pink, _currentIndex, 1,
                    _onItemTapped),
                sideBarItem("Statics", Icons.timeline, Colors.indigo,
                    _currentIndex, 2, _onItemTapped),
                sideBarItem("More", Icons.more_horiz, Colors.teal, _currentIndex,
                    3, _onItemTapped),
              ],
            ),
          ),
          Expanded(
              flex: 6,
              child: LibraryScreen(
                animePage: (newAnime) {
                  setState(() {
                    anime = newAnime;
                    showAnimeDetails = true;
                  });
                },
              )),
          VerticalDivider(
            width: 3,
            thickness: 8,
            color: Colors.grey.withOpacity(.3),
          ),
          if (!showAnimeDetails)
            Expanded(
                flex: 3,
                child: _currentIndex != 0
                    ? pagesList[_currentIndex]
                    : SearchScreen(
                        onAnimeSelected: (value) {
                          setState(() {
                            anime = value;
                            showAnimeDetails = true;
                          });
                        },
                      )),
          if (showAnimeDetails)
            Expanded(
              flex: 3,
              child: AnimeDetailsScreen(
                anime: anime,
                openAnime: () {
                  setState(() {
                    anime = animeDetailPlaceHolder;
                  });
                },
                closeDetails: () {
                  setState(() {
                    showAnimeDetails = false;
                    anime = animeDetailPlaceHolder;
                  });
                },
              ),
            )
        ],
      ),
    );
  }
}
