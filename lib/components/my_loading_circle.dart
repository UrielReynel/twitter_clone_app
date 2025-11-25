import 'package:flutter/material.dart';

//Show loading circle dialog
void showLoadingCircle(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(),
      ),
    )
  );
}

//Hide loading circle dialog
void hideLoadingCircle(BuildContext context) {
  Navigator.pop(context);
}