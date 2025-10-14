import 'package:flutter/material.dart';

void showSnackbar({required BuildContext context, required SnackBar snackBar}) {
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
