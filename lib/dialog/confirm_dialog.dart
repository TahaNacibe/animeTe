import 'package:flutter/material.dart';

Future<bool> showConfirmWipeDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Confirm Data Wipe',
          style: TextStyle(
            fontFamily: "Quick",
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: const Text(
          'Are you sure you want to wipe all data? This action cannot be undone.',
          style: TextStyle(
            fontFamily: "Quick",
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
