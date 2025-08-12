import 'dart:math';
import 'package:flutter/material.dart';
import 'appState.dart';
import 'FirstPage.dart';
import 'storageHelper.dart';

final randomizer = Random();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {


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
        title: const Text('LoginPage', style: TextStyle(fontSize: 30)),
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
          child: Text("LoginPage"),
        ),
      ),
    );
  }
}