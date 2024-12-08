import 'package:animeate/pages/Android/screens/library_screen.dart';
import 'package:animeate/pages/Android/screens/more_screen.dart';
import 'package:animeate/pages/Android/screens/news_screen.dart';
import 'package:animeate/pages/Android/screens/search_screen.dart';
import 'package:animeate/pages/Android/screens/statics_screen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  //* Pages list
  List<Widget> pagesList = [
    const LibraryScreen(),
    const NewsScreen(),
    const SearchScreen(),
    const StaticsScreen(),
    const MoreScreen(),
  ];

  //* Current index for the selected page
  int _currentIndex = 0;

  //* Page controller
  PageController pageScrollController = PageController();

  //* UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenBody(),
      bottomNavigationBar: bottomBar(),
    );
  }

  //* Widget for the body 
  Widget screenBody() {
    return PageView.builder(
      controller: pageScrollController,
      itemCount: pagesList.length,
      onPageChanged: (value) {
        setState(() {
          _currentIndex = value; // Update current index on page change
        });
      },
      itemBuilder: (context, index) {
        return pagesList[index]; // Return the page based on index
      },
    );
  }

  //* Bottom navigation bar 
  Widget bottomBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(.2), width: 1.5),
        ),
      ),
      child: SalomonBottomBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() {
          _currentIndex = i; // Update current index on tap
          pageScrollController.animateToPage(
            _currentIndex,
            duration: const Duration(seconds: 1),
            curve: Curves.ease,
          );
        }),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.book),
            title: const Text("Library"),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.update),
            title: const Text("Updates"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.timeline),
            title: const Text("Statics"),
            selectedColor: Colors.indigo,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.more_horiz),
            title: const Text("More"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
