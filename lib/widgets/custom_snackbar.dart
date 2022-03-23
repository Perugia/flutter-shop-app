import 'package:flutter/material.dart';

void customSnack({
  required BuildContext context,
  required Widget content,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 1),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 31, 35, 38),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      duration: duration,
      action: action,
    ),
  );
}
