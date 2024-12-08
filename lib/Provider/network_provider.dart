import 'package:animeate/dialog/fast_snack_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//* check if the app is connected
Future<bool> checkConnectivity() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult.isNotEmpty;
}

//* open url
Future<void> openUrlInBrowser(String url, BuildContext context) async {
  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,  // Ensures external browser is used
      );
      showFastSnackBar(context, "Opening Link", Colors.indigo, Icons.done);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    showFastSnackBar(context, "Failed to open link: $e", Colors.red, Icons.error);
    print('Something went wrong: $e');
  }
}

