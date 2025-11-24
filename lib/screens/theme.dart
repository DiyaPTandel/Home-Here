import 'package:flutter/material.dart';

final ThemeData userTheme = ThemeData(
  primarySwatch: Colors.blue,
  useMaterial3: false,
);

final ThemeData ownerTheme = ThemeData(
  primaryColor: const Color(0xFF004AAD),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF004AAD),
    secondary: const Color(0xFF004AAD),
  ),
  useMaterial3: false,
);
