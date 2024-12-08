import 'package:animeate/Provider/shared_prefernces.dart';
import 'package:animeate/Services/statics_services.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/achivments/achievement_services.dart';
import 'package:animeate/achivments/achivment.dart';
import 'package:animeate/achivments/achivmentsArchive.dart';
import 'package:animeate/pages/widgets/darken_color.dart';
import 'package:animeate/pages/widgets/widget_lable.dart';
import 'package:flutter/material.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  //* functions
  void achievementsHandler() {
    watchCaseAchievement(getTopGenresForYou());
    currentUserSettings.achievements = achievementKeyList;
    saveSettingsToStorage(currentUserSettings);
  }

  //* Ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* appBar
      appBar: staticsAppBar(),

      //* body tree
      body: staticsBody(),
    );
  }

  //* appBar widget
  PreferredSizeWidget staticsAppBar() {
    return AppBar(
      title: const Text(
        "Statics",
        style: TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  //* body of the statics screen
  Widget staticsBody() {
    return ListView(
      children: [
        //* title divider
        titleDivider(),

        //* states bar
        detailsBar(),

        const SizedBox(height: 16),

        //* show genres ranking
        genresBuilder(),

        //* the achievements sheet
        achievementsSheetWidget()
      ],
    );
  }

  //* title divider widget
  Widget titleDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Text("Your States:", style: TextStyle(fontSize: 21)),
          Padding(
            padding: EdgeInsets.only(left: 150.0),
            child: Divider(),
          )
        ],
      ),
    );
  }

  //* details bar (user states)
  Widget detailsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        widgetLabel(title: "In Library", value: getTotalAnime().toString()),
        widgetLabel(title: "Categories", value: getLibrariesCount().toString()),
        widgetLabel(title: "Episodes", value: getTotalEpisodes().toString()),
      ],
    );
  }

  //* genres builder
  Widget genresBuilder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Builder(
        builder: (context) {
          //* order the genres the user have in the library
          final genreData = getTopGenresForYou().entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          achievementsHandler();

          //* Ui
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List<Widget>.generate(genreData.length, (index) {
              //* vars settings
              final entry = genreData[index];
              final color = Colors.primaries[index % Colors.primaries.length];

              //* Ui
              return genreItemWidget(entry: entry, color: color, index: index);
            }),
          );
        },
      ),
    );
  }

  //* genre item widget
  Widget genreItemWidget(
      {required MapEntry<String, dynamic> entry,
      required MaterialColor color,
      required int index}) {
    //*Ui
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          if (index == 0) Icon(Icons.star, color: color.darken(), size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.darken(),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  entry.value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.darken(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //* achievements sheet body widget
  Widget achievementsSheetWidget() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.1),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(3, 0))
              ]),
          child: Center(
              child: achievementKeyList.isEmpty
                  ? emptyAchievementsSheet()
                  : achievementsPageBuilder())),
    );
  }

  //* widget achievements sheet empty
  Widget emptyAchievementsSheet() {
    return const Text(
      "(=u=)",
      style: TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 30),
    );
  }

  //* achievements builder
  Widget achievementsPageBuilder() {
    return PageView.builder(
      itemCount: achievementKeyList.length,
      itemBuilder: (context, index) {
        return achievementItemWidget(achievementKeyList[index]);
      },
    );
  }

  //* individual achievement item widget
  Widget achievementItemWidget(String achievementKey) {
    Achievement achievementInstance = achievements[achievementKey];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                achievementInstance.name,
                style: const TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.indigo,
                    size: 25,
                  ),
                  Text(
                    achievementInstance.rarity.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.indigo),
                  )
                ],
              )
            ],
          ),
          Text(
            achievementInstance.desc,
            style: const TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.w500,
                fontSize: 22),
          ),
        ],
      ),
    );
  }
}
