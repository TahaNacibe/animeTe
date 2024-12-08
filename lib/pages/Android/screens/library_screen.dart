import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/pages/Android/screens/anime_details_screen.dart';
import 'package:animeate/Provider/shared_prefernces.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/display_settings.dart';
import 'package:animeate/dialog/new_category_dialog.dart';
import 'package:animeate/pages/widgets/more_item.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  final void Function(AnimeItem anime)? animePage;
  const LibraryScreen({this.animePage, super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  //* var settings
  bool isSearch = false;
  int categoryIndex = 0;
  int crossCount = currentUserSettings.gridCount;
  bool showNames = currentUserSettings.showNames;
  bool showClearCover = currentUserSettings.clearCover;

  //* controllers section
  TextEditingController searchController = TextEditingController();
  ScrollController categoriesController = ScrollController();
  TabController? tabController;

  //* set the active cell index
  void setActiveCellIndex({required int index}) {
    setState(() {
      categoryIndex = index;
    });
  }

  //* fast update to the display settings
  void displayFastUpdate(
      {required int slide, required bool clearCover, required bool showName}) {
    setState(() {
      crossCount = slide;
      showNames = showName;
      showClearCover = clearCover;
      currentUserSettings.gridCount = slide;
      currentUserSettings.clearCover = clearCover;
      currentUserSettings.showNames = showNames;
      saveSettingsToStorage(currentUserSettings);
    });
  }

  //* change active page on delete
  void changeActivePageOnDelete({required int value}) {
    if (value == categoryIndex) {
      if (categoryIndex >= 1) {
        categoryIndex -= 1;
      } else {
        categoryIndex = 0;
      }
    }
  }

  @override
  void initState() {
    loadCategoryList(context).then((value) {
      setState(() {
        userCategoriesList = value;
      });
    });
    tabController =
        TabController(length: userCategoriesList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: libraryAppBar(),
      body: TabBarView(
        controller: tabController,
        children: [
          for (int i = 0; i < userCategoriesList.length; i++)
            buildCategoryTab(i),
        ],
      ),
    );
  }

  //* build each category tab
  Widget buildCategoryTab(int index) {
    final items = userCategoriesList[index].items;
    return items.isNotEmpty ? itemScreenDisplay(index) : emptyLibraryDisplay();
  }

  //* empty library widget
  Widget emptyLibraryDisplay() {
    return const Center(
      child: Text(
        "There's Nothing here...\n(!^~^)/",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }

  //* items screen (library screen items builder)
  Widget itemScreenDisplay(int index) {
    return isSearch
        ? itemBuilderForSearch(index)
        : itemBuilderForLibrary(index);
  }

  //* the section where all the items are getting build and displayed
  Widget itemBuilderForLibrary(int index) {
    final items = userCategoriesList[index].items;
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: .65,
        crossAxisCount: crossCount,
      ),
      itemBuilder: (context, i) {
        AnimeItem item = items[i];
        return GestureDetector(
          onTap: () {
            if (isThePlatformWindows()) {
              widget.animePage!(item);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailsScreen(anime: item),
                ),
              ).then((_) => setState(() {}));
            }
          },
          child: additionalItems(
            title: item.title,
            url: item.bigImage,
            context: context,
            padding: 4,
            showName: showNames,
            clearView: !showClearCover,
          ),
        );
      },
    );
  }

  //* the section where all the items are getting build and displayed in the search state
  Widget itemBuilderForSearch(int index) {
    List<dynamic> filteredList = userCategoriesList[index]
        .items
        .where((item) => item.title
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
    return GridView.builder(
      itemCount: filteredList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: .65,
        crossAxisCount: crossCount,
      ),
      itemBuilder: (context, i) {
        AnimeItem item = filteredList[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnimeDetailsScreen(anime: item)),
            );
          },
          child: additionalItems(
            title: item.title,
            url: item.bigImage,
            context: context,
            padding: 4,
            showName: showNames,
            clearView: showClearCover,
          ),
        );
      },
    );
  }

  //* library app bar widget section
  PreferredSizeWidget libraryAppBar() {
    return AppBar(
      title: isSearch
          ? null
          : const Text(
              "Library",
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
      actions: [
        if (isSearch)
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.2,
            child: TextField(
              onChanged: (value) => setState(() {}),
              controller: searchController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search...",
                hintStyle: TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        IconButton(
          onPressed: () {
            setState(() {
              isSearch = !isSearch;
              searchController.clear();
            });
          },
          icon: Icon(isSearch ? Icons.close : Icons.search, size: 30),
        ),
        if (!isSearch)
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                // isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: DisplaySettingsBottomSheet(
                        categories: userCategoriesList,
                        itemsPerRow: crossCount,
                        showNames: showNames,
                        showClearCover: showClearCover,
                        save: (slide, name, cover) {
                          setState(() {
                            displayFastUpdate(
                                slide: slide,
                                clearCover: cover,
                                showName: name);
                          });
                        },
                        refreshPage: () => setState(() {}),
                        refreshPageDelete: (value) => setState(() {
                          changeActivePageOnDelete(value: value);
                        }),
                        onReorder: ({required newIndex, required oldIndex}) {
                          setState(() {
                            final item = userCategoriesList.removeAt(oldIndex);
                            userCategoriesList.insert(newIndex, item);
                            saveCategoriesListToStorage(userCategoriesList);
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.menu, size: 30),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.add, size: 30),
              onPressed: () {
                showAddCategoryDialog(
                  context: context,
                  addItem: () => setState(() {
                    tabController = TabController(
                        length: userCategoriesList.length, vsync: this);
                  }),
                );
              },
            ),
            Expanded(
              child: TabBar(
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).iconTheme.color,
                indicatorColor: Theme.of(context).iconTheme.color,
                controller: tabController,
                isScrollable: true,
                tabs: [
                  for (int i = 0; i < userCategoriesList.length; i++)
                    Tab(
                      child: Text(
                        userCategoriesList[i].name,
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                    ),
                ],
                onTap: (index) {
                  setActiveCellIndex(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
