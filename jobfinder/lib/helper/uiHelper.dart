import 'package:flutter/material.dart';

class UiHelper {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color.fromARGB(255, 85, 143, 151).withOpacity(.5),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
