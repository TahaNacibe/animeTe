import 'package:animeate/Provider/shared_prefernces.dart';
import 'package:animeate/Provider/theme_providers.dart';
import 'package:animeate/Services/settings_services.dart';
import 'package:animeate/Shared/place_Holders.dart';
import 'package:animeate/dialog/confirm_dialog.dart';
import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:animeate/widget/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  //* var
  int tapCounter = 0;

  //* functions
  // confirm the delete situation
  void deleteAllDialogManager() async {
    bool result = await showConfirmWipeDialog(context);
    if (result) {
      // Proceed with wiping all data
      deleteAllData(context);
    } else {
      // User cancelled the action
      showFastSnackBar(context, "Canceled By user", Colors.green, Icons.info);
    }
  }

  // check hentai option state
  void checkHentaiSituation() {
    if (tapCounter >= 20) {
      setState(() {
        currentUserSettings.activateSfw = true;
        saveSettingsToStorage(currentUserSettings);
        tapCounter = 0;
      });
    } else {
      tapCounter += 1;
    }
  }

  //* UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //* app bar widget
        appBar: settingsAppBar(),
        //* display settings
        body: settingsPage());
  }

  //* app bar widget body
  PreferredSizeWidget settingsAppBar() {
    return AppBar(
      title: const Text(
        "More",
        style: TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  //* setting page body
  Widget settingsPage() {
    //* providers
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    //* Ui
    return ListView(
      children: [
        //* change theme
        settingItems(
          name: themeProvider.isDarkTheme ? "Light Mode" : "Dark Mode",
          icon: themeProvider.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
          rightHand: Switch(
            value: themeProvider.isDarkTheme,
            onChanged: (value) {
              setState(() {
                themeProvider.toggleTheme();
              });
            },
          ),
        ),

        //* load backUp
        GestureDetector(
            onTap: () {
              loadBackup(context);
            },
            child: settingItems(name: "Load BackUp", icon: Icons.refresh)),

        //* create backUp
        GestureDetector(
            onTap: () {
              createBackup(userCategoriesList, context);
            },
            child: settingItems(name: "Create BackUp", icon: Icons.download)),

        //* delete all items
        GestureDetector(
            onTap: () async {
              deleteAllDialogManager();
            },
            child: settingItems(name: "Delete All", icon: Icons.delete)),

        //* help
        settingItems(name: "Help", icon: Icons.help, sub: "Coming soon..."),

        //* info
        GestureDetector(
            onTap: () {
              //* update counter
              checkHentaiSituation();
            },
            child:
                settingItems(name: "Info", icon: Icons.info, sub: "v 1.0.0")),

        if (currentUserSettings.activateSfw)
          //* hentai option
          settingItems(
              name: "Show Hentai",
              icon: Icons.lock,
              sub: currentUserSettings.sfw ? "On" : "Off",
              rightHand: Switch(
                  value: currentUserSettings.sfw,
                  onChanged: (value) {
                    setState(() {
                      currentUserSettings.sfw = value;
                      saveSettingsToStorage(currentUserSettings);
                    });
                  }))
      ],
    );
  }
}
