import 'package:animeate/Api/jikan_api.dart';
import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/widget/search_item.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final void Function(AnimeItem anime)? onAnimeSelected;
  const SearchScreen({this.onAnimeSelected, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //* settings var
  bool isSearch = false;
  bool isSearchResult = false;
  bool isReadOnly = true;
  int resultTotal = 0;

  //* sizing vars
  double windowsScreenWidth = 4.2;
  double androidScreenWidth = 1.2;

  //* controllers section
  TextEditingController searchController = TextEditingController();

  //* check the current use state
  bool isTheUserSearching() => (isSearch && searchController.text.isNotEmpty);

  //* widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //* the section app bar
        appBar: searchAppBar(),
        //* page body
        body: isSearchResult

            //* in case the user is searching
            ? searchResultSection()

            //* in case the user is not searching
            : searchWaitSection());
  }

  //* search app bar
  PreferredSizeWidget searchAppBar() {
    return AppBar(
        // show the title when the search is off
        title: isSearch
            ? null
            : GestureDetector(
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                child: const Text(
                  "Search",
                  style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),

        //* search icon
        actions: searchSection());
  }

  //* search section
  List<Widget> searchSection() {
    //* size vars
    double activeScreenSize =
        isThePlatformWindows() ? windowsScreenWidth : androidScreenWidth;

    //* functions
    void applySearchState() {
      setState(() {
        // if the search is in the search case and the controller is not empty search
        isTheUserSearching() ? isSearchResult = true : isSearch = !isSearch;
        isReadOnly = true;
      });
    }

    //* UI
    return [
      if (isSearch) //show the search if it true
        //* search bar
        SizedBox(
          width: MediaQuery.sizeOf(context).width / activeScreenSize,
          child: TextField(
            // controller
            controller: searchController,
            autofocus: false,
            readOnly: isReadOnly,
            onTap: () {
              //* change the search field along the action 
              setState(() {
                isReadOnly = !isReadOnly;
              });
            },
            decoration: const InputDecoration(
              // remove the border
              border: InputBorder.none,
              // hint decoration and text
              hintText: "Search...",
              hintStyle: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            // search input style
            style: const TextStyle(
              fontFamily: "Quick",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      //* search button
      IconButton(
          onPressed: () {
            applySearchState();
          },
          icon: const Icon(Icons.search)),
    ];
  }

  //* search result display
  Widget searchResultSection() {
    return FutureBuilder(
        // function to fetch the data based on string name
        future: searchAnimeByName(
            searchController.text, context, currentUserSettings.sfw),
        // return the data in a formate
        builder: (BuildContext context, snapshot) {
          //* in loading case
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget();
          } else if (snapshot.connectionState == ConnectionState.none) {
            //* in error case
            return errorDisplayWidget();
          } else {
            //* in succuss case
            List<dynamic>? searchResult =
                snapshot.data; // set the data the snapshot have

            //* in case of a null response show the error
            if (searchResult == null) {
              return errorDisplayWidget();
            }
            //* search result body
            return searchResultSuccuss(searchResult: searchResult);
          }
        });
  }

  //* search result succuss
  Widget searchResultSuccuss({required List<dynamic> searchResult}) {
    //* create vars for the length
    resultTotal = searchResult.length;

    //* Ui
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          // item count
          itemCount: searchResult.length,
          // setting the item layout
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 3),
          // return the widget
          itemBuilder: (context, index) {
            return searchItem(
              anime: searchResult[index],
              context: context,
              onAnimeSelected: (anime) {
                if (widget.onAnimeSelected != null) {
                  widget.onAnimeSelected!(anime);
                }
              },
            );
          }),
    );
  }

  //* error widget
  Widget errorDisplayWidget() {
    return const Center(
        child: Text(
      "That's Weird\n(0=0)",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 25),
    ));
  }

  //* loading widget
  Widget loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  //* search waiting screen
  Widget searchWaitSection() {
    return const Center(
      child: Text(
        "What will you search now?\n(^=^!)",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, fontFamily: "Quick"),
      ),
    );
  }
}
