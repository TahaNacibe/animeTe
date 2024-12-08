import 'dart:ui';
import 'package:animeate/Api/jikan_api.dart';
import 'package:animeate/Models/related_item.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:animeate/pages/Android/screens/anime_details_screen.dart';
import 'package:animeate/pages/widgets/more_item.dart';
import 'package:flutter/material.dart';

//* Convert relatedToPage into a StatefulWidget
class RelatedToPage extends StatefulWidget {
  final VoidCallback showItem;
  final String animeId;

  const RelatedToPage(
      {super.key, required this.showItem, required this.animeId});

  @override
  State<RelatedToPage> createState() => _RelatedToPageState();
}

class _RelatedToPageState extends State<RelatedToPage> {
  //* vars
  Map<String, List<RelatedItem>>? items; // Changed to nullable
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    getAnimeRelations(widget.animeId, context, currentUserSettings.sfw)
        .then((data) {
      setState(() {
        items = data;
        isLoading = false; // Set loading to false after data is fetched
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator(); // Show loading indicator
    } else if (items == null || items!.isNotEmpty) {
      return _buildRelatedItemsList(widget.showItem, items!);
    } else {
      return _buildErrorMessage();
    }
  }
}

// Loading indicator widget
Widget _buildLoadingIndicator() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: CircularProgressIndicator(),
    ),
  );
}

// Error message widget
Widget _buildErrorMessage() {
  return const Center(
    child: Text(
      "Something went wrong\n (^u^?)",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Quick",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}

// Main content widget for related items
Widget _buildRelatedItemsList(
    VoidCallback showItem, Map<String, List<RelatedItem>> items) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.entries.map((entry) {
        return _buildCategorySection(showItem, entry.key, entry.value);
      }).toList(),
    ),
  );
}

// Widget for each category of related items
Widget _buildCategorySection(
    VoidCallback showItem, String category, List<RelatedItem> relatedItems) {
  return Builder(builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 80, right: 24),
              child: Divider(),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                category,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quick"),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 240,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    getAnimeById(relatedItems[index].id.toString(), context)
                        .then((value) {
                      if (value.title != "404") {
                        if (isThePlatformWindows()) {
                          animeDetailPlaceHolder = value;
                          showItem();
                        } else {
                          Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AnimeDetailsScreen(anime: value)));
                        }
                      } else {
                        showFastSnackBar(context, "Can't Show that Item",
                            Colors.indigo, Icons.info);
                      }
                    });
                  },
                  child: SizedBox(
                    height: 220,
                    width: 170,
                    child: additionalItems(
                      title: relatedItems[index].title,
                      url: relatedItems[index].image,
                      context: context,
                      clearView: true,
                      padding: 8,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  });
}
