import 'package:flutter/material.dart';
import 'package:online_casino/FirstPage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Online Casino',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // Optional: flache AppBar
      ),
        primarySwatch: Colors.green,
      fontFamily: 'VarelaRound',
    ),
    home: const FirstPage(),
  ));

  }







