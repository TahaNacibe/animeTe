import 'package:animeate/Models/episode_item.dart';
import 'package:animeate/Provider/network_provider.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/Services/time_services.dart';
import 'package:animeate/widget/filled_tag.dart';
import 'package:flutter/material.dart';

void showSimpleEpisodeEditSheet(
    BuildContext context, EpisodeItem episode, String cover) {
  //* vars for control
  bool expandText = false;
  bool isItWindows = isThePlatformWindows();
  //* widget tree
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the sheet to expand
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      //* size vars
      double width = MediaQuery.sizeOf(context).width - 35;
      double height = MediaQuery.sizeOf(context).width / 2;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(builder: (context, setState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize:
                 0.7, // Initial size of the sheet
              minChildSize:
                  isItWindows ? .5 : 0.3, // Minimum size when collapsed
              maxChildSize: 0.9, // Maximum size when expanded
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //* episode image cover and play icon
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImage(cover),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(.7),
                              ),
                              child: const Icon(
                                Icons.play_circle,
                                size: 40,
                              ),
                            ),
                            //* Title cover and black over lay
                            Container(
                              alignment: Alignment.bottomLeft,
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  episode.title,
                                  style: const TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            //* tags
                            Container(
                              height: height,
                              width: width,
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      //* Filler Tag
                                      if (episode.filler)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: typeBudge("Filler"),
                                        ),
                                      if (episode.recap)
                                        //* Recap Tag
                                        typeBudge("Recap")
                                    ],
                                  ),
                                  typeBudge(getEpDuration(episode.duration))
                                ],
                              ),
                            ),
                          ],
                        ),
                        //* description section
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "In this Episode:",
                                style: TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              const Divider(),
                              Text(
                                episode.synopsis,
                                maxLines: expandText ? null : 3,
                                overflow:
                                    expandText ? null : TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expandText = !expandText;
                                  });
                                },
                                child: Text(
                                  expandText ? "Show Less..." : "...Show More",
                                  style: const TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        //* watch button
                        GestureDetector(
                          onTap: () {
                            openUrlInBrowser(episode.url, context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            width: width,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.indigo),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Watch The Episode",
                                  style: TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 35,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      );
    },
  );
}
