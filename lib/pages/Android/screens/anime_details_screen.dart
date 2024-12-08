import 'dart:ui';
import 'package:animeate/Api/jikan_api.dart';
import 'package:animeate/DetailsSheets/episodes_details.dart';
import 'package:animeate/Models/anime_item.dart';
import 'package:animeate/Provider/network_provider.dart';
import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/Services/categories_services.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/add_entrey_dialog.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:animeate/icons/my_flutter_app_icons.dart';
import 'package:animeate/pages/more_like.dart';
import 'package:animeate/pages/related_page.dart';
import 'package:animeate/widget/anime_details_bar.dart';
import 'package:animeate/widget/border_text.dart';
import 'package:animeate/widget/episodes_item.dart';
import 'package:animeate/widget/glow_button.dart';
import 'package:animeate/widget/section_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimeDetailsScreen extends StatefulWidget {
  //* the anime instance
  final AnimeItem anime;
  final VoidCallback? closeDetails;
  final VoidCallback? openAnime;
  const AnimeDetailsScreen(
      {this.closeDetails, this.openAnime, required this.anime, super.key});

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  //* var
  bool isDescriptionFolded = true;
  int activeIndex = 0;
  int descriptionMaxLines = 3;

  //* size vars
  double expandedHeight = 3.4;
  double windowsScreenWidth = 4.5;
  double androidScreenWidth = 1.5;
  double windowsSearchWidth = 6;
  double androidSearchWidth = 2;

  //* check internet connectivity
  bool internetState = false;

  //* check is the platform indows place holder
  bool isItWindows = false;

  //* controllers section
  TextEditingController searchEpController = TextEditingController();

  //* create the age tag text
  String ageTag(String fullTag) {
    return fullTag.split(" ")[0];
  }

  //* set default
  String setDefault(String value) {
    return value == "null" ? "N/A" : value;
  }

  //* manage section switch
  void switchActiveSection({required int index}) {
    setState(() {
      activeIndex = index;
    });
  }

  //* initial state
  @override
  void initState() {
    // check internet state to fetch the data
    checkConnectivity().then((value) {
      setState(() {
        internetState = value;
      });
    });

    // check platform type
    isItWindows = isThePlatformWindows();
    super.initState();
  }

  //* widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* costume scroll main body
      body: CustomScrollView(
        slivers: <Widget>[
          //* app bar costume view
          sliverAppBar(),

          //* body widget tree
          sliverListBody(),
        ],
      ),
    );
  }

  //* sliver costume app Bar widget
  Widget sliverAppBar() {
    return SliverAppBar(
      expandedHeight: MediaQuery.sizeOf(context).height / expandedHeight,
      floating: false,
      pinned: true,
      //* close section in case of windows
      leading: isItWindows
          ? GestureDetector(
              onTap: () {
                widget.closeDetails!();
              },
              child: const Icon(Icons.close))
          : null,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          //* vars to use in that situation needed to be here to access the hight
          double top = constraints.biggest.height;
          double collapsedHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight;

          //* check the collapse state
          bool isCollapsed = top <= collapsedHeight;

          //* widget tree
          return FlexibleSpaceBar(
            title: isCollapsed ? Text(widget.anime.title) : null,
            background: Stack(
              fit: StackFit.expand,
              children: [
                // bg image
                Image(
                  image: CachedNetworkImageProvider(widget.anime.bigImage),
                  fit: BoxFit.cover,
                ),
                // the over lay section
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).cardColor.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //* sliver list body
  Widget sliverListBody() {
    //* get episodes count
    int episodes = int.tryParse(widget.anime.episodes) ?? 0;

    //* sizing vars
    double screenWidth = isItWindows ? windowsScreenWidth : androidScreenWidth;

    //* Ui
    return SliverList(
      delegate: SliverChildListDelegate([
        //* title and library button section
        titleBar(screenWidth: screenWidth),

        //* rating, year and border tags for the quality and age tag
        secondInformationRow(),

        //* download and play button
        buttonBars(),

        //* genres (just jon the list items not a big deal doesn't require a separate function)
        generalistWidget(),

        //* description and extra info row section
        descriptionAndExtraInfoRow(),

        //* episodes search section
        searchEpisodeSection(),

        //* episodes list section
        episodesMainBody(episodes: episodes),

        //* switch into sections (related/similar)
        sectionsButtonBars(),

        //* active section body
        itemsRelatedRecommended()
      ]),
    );
  }


  //* title and save library section
  Widget titleBar({required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title widget
          SizedBox(
            width: MediaQuery.sizeOf(context).width / screenWidth,
            child: Text(
              setDefault(widget.anime.title),
              style: const TextStyle(
                  fontFamily: "Quick",
                  fontWeight: FontWeight.bold,
                  fontSize: 23),
            ),
          ),
          // library button and share option
          Row(
            children: [
              //* add entry to the library
              IconButton(
                  onPressed: () {
                    showListDialog(context, userCategoriesList, widget.anime,
                        () => setState(() {}));
                  },
                  icon: Icon(
                    //* check if the item exist in a category
                    theEntryIsInCategory(anime: widget.anime)
                        ? MyFlutterApp.bookmark_1
                        : MyFlutterApp.bookmark,
                    color: Colors.indigo,
                  )),
              //* share the entry option
              IconButton(
                  onPressed: () {
                    openUrlInBrowser(widget.anime.url, context);
                  },
                  icon: const Icon(MyFlutterApp.paper_plane)),
            ],
          )
        ],
      ),
    );
  }


  //* year tag score age tag and more ...
  Widget secondInformationRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.indigo,
            size: 20,
          ),

          //* score
          Text.rich(TextSpan(children: [
            TextSpan(
                text: "  ${setDefault(widget.anime.score)}   >   ",
                style: const TextStyle(
                    fontFamily: "Quick",
                    fontSize: 16,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold)),

            //* year
            TextSpan(
                text: setDefault(widget.anime.airYear),
                style: const TextStyle(
                    fontFamily: "Quick",
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
          ])),

          //* the anime age tag
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: typeBudget(ageTag(setDefault(widget.anime.rating))),
          ),

          //* just ignore that (*u*)!
          typeBudget("HD"),
        ],
      ),
    );
  }


  //* buttons bar
  Widget buttonBars() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          //* play button
          GestureDetector(
            onTap: () {
              // open url in browser ...i mean it's self explanatory
              openUrlInBrowser(widget.anime.url, context);
            },
            child: glowingButton(
                name: "Play",
                color: Colors.indigo,
                icon: Icons.play_circle,
                context: context),
          ),
          GestureDetector(
            onTap: () {
              // small explanation since the api don't allow downloading
              showFastSnackBar(context, "Isn't available in the moment",
                  Colors.indigo, Icons.info);
            },
            child: glowingButton(
                name: "Download",
                color: Colors.indigo,
                icon: MyFlutterApp.download,
                context: context,
                isFilled: false),
          )
        ],
      ),
    );
  }


  //* description and extra info section
  Widget descriptionAndExtraInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // description
          Text(
            // replace the null String with N/A to avoid displaying null
            setDefault(widget.anime.synopsis),
            maxLines: isDescriptionFolded ? descriptionMaxLines : null,
            overflow: isDescriptionFolded ? TextOverflow.ellipsis : null,
            style: const TextStyle(
                fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 15),
          ),
          // the extra info section
          if (!isDescriptionFolded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              // more info section
              child: animeDetailsBar(
                  studio: widget.anime.studio,
                  source: widget.anime.source,
                  rank: widget.anime.rank),
            ),
          GestureDetector(
            onTap: () {
              // switch state button
              setState(() {
                isDescriptionFolded = !isDescriptionFolded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isDescriptionFolded ? "...View More" : "View Less...",
                style: const TextStyle(
                    fontFamily: "Quick",
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }


  //* search section bar
  Widget searchEpisodeSection() {
    //* sizing var
    double searchBarWidth =
        isItWindows ? windowsSearchWidth : androidSearchWidth;

    //* Ui body
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Episodes",
            style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        // search filed
        SizedBox(
          width: MediaQuery.sizeOf(context).width / searchBarWidth,
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(),
            controller: searchEpController,
            onChanged: (value) {
              setState(() {});
            },
            // decoration
            decoration: InputDecoration(
                prefixIcon: const Icon(MyFlutterApp.search),
                hintText: "Search Episodes",
                hintStyle: const TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                border: borderSetting,
                focusedBorder: borderSetting,
                enabledBorder: borderSetting),
          ),
        )
      ],
    );
  }


  //* Episodes List main body
  Widget episodesMainBody({required int episodes}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        height: 150,
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              // allow moving in windows and android
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),

            // show the cordoning widget
            child: episodes == 0
                ? failToLoadEpisodesWidget()
                : episodesListBody(episodes: episodes)),
      ),
    );
  }


  //* error loading episodes Widget
  Widget failToLoadEpisodesWidget() {
    return const Center(
      child: Text(
        "No Episodes ...That's Weird\n(&u&!)",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }


  //* episodes List widget
  Widget episodesListBody({required int episodes}) {
    return ListView.builder(
      // put a zero in case the list length wasn't a number
      itemCount: episodes,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // UI
        return Visibility(
          // hide if the search input have data and it don't equal what is here
          visible: "${index + 1}".contains(searchEpController.text),
          child: GestureDetector(
            onTap: () async {
              //* check internet connectivity
              if (internetState) {
                // get ep data
                getSpecificEpisode(widget.anime.animeId, index + 1, context)
                    .then((onValue) {
                  // show Ui
                  showSimpleEpisodeEditSheet(
                      context, onValue, widget.anime.bigImage);
                });
              }
            },
            // Return episode costume widget
            child: episodeWidget(index: index, url: widget.anime.bigImage),
          ),
        );
      },
    );
  }


  //* section buttons bar
  Widget sectionsButtonBars() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        children: [
          sectionButton(
              sectionIndex: 0,
              activeIndex: activeIndex,
              sectionName: "More Like this",
              refreshFunction: () => switchActiveSection(index: 0)),
          sectionButton(
              sectionIndex: 1,
              activeIndex: activeIndex,
              sectionName: "Related",
              refreshFunction: () => switchActiveSection(index: 1))
        ],
      ),
    );
  }


  //* Widget of the related / recommended section
  Widget itemsRelatedRecommended() {
    return internetState
        ? Column(
            children: [
              if (activeIndex == 0)
                //* the sections body
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: MoreLikePage(
                        showItem: widget.openAnime ?? () {},
                        animeId: widget.anime.animeId)),
              if (activeIndex == 1)
                //* related body section
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: RelatedToPage(
                      showItem: widget.openAnime ?? () {},
                      animeId: widget.anime.animeId,
                    ))
            ],
          )
        : const SizedBox.shrink();
  }


  //* genres List widget
  Widget generalistWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
      child: Text(
        "Genre: ${widget.anime.genres.join(",")}",
        style: const TextStyle(
            fontFamily: "Quick", fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
