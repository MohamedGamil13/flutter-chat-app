import 'package:flutter/material.dart';

void ShowsSnackBar(BuildContext context, String massege) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massege)));
}
