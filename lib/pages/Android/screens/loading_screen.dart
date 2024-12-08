import 'package:animeate/Provider/platform_service.dart';
import 'package:animeate/Provider/shared_prefernces.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    loadCategoryList(context).then((value) {
      userCategoriesList = value;
      loadSettingsFromStorage(context).then((settingValue) {
        currentUserSettings = settingValue;
        print(settingValue.toJson());
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.popAndPushNamed(
              context, (isThePlatformWindows() ? "HomeWindows" : "HomeMobile"));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //*
        Image.asset(
          "assets/images/motion.png",
          width: 75,
          height: 75,
        ),
        //*
        SizedBox(
          height: 75,
        ),
        //*
        LoadingAnimationWidget.inkDrop(
          color: Colors.indigo,
          size: 40,
        ),
      ],
    )));
  }
}
