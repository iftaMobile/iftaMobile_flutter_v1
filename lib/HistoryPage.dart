import 'dart:math';
import 'package:flutter/material.dart';
import 'appState.dart';
import 'FirstPage.dart';
import 'storageHelper.dart';

final randomizer = Random();

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FirstPage()),
          ),
        ),
        title: const Text('HistoryPage', style: TextStyle(fontSize: 30)),
        actions: [
          IconButton(
            iconSize: 20,
            icon: Image.asset('assets/images/Button6_200x200px.png', height: 160),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FirstPage()),
            ),
          ),
          IconButton(
            iconSize: 20,
            icon: Image.asset('assets/images/Button7_200x200px.png', height: 160),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FirstPage()),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text("HistoryPage"),
        ),
      ),
    );
  }
}