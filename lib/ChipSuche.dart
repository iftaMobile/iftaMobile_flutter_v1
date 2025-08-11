import 'dart:math';
import 'package:flutter/material.dart';

import 'appState.dart';
import 'package:online_casino/FirstPage.dart';
import 'storageHelper.dart';

final randomizer = Random();

class ChipSuche extends StatefulWidget {
  const ChipSuche({super.key});

  @override
  State<ChipSuche> createState() => _ChipSucheState();
}

class _ChipSucheState extends State<ChipSuche> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  int input = 0;
  int input1 = 0;
  int input2 = 0;

  void _submit() {
    setState(() {
      input = int.tryParse(_controller.text) ?? 0;
      input1 = int.tryParse(_controller1.text) ?? 0;
      input2 = int.tryParse(_controller2.text) ?? 0;

      if (input1 < 1 || input1 > 70 || input2 < 1 || input2 > 70) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte geben Sie Zahlen zwischen 1 und 70 ein.', style: TextStyle(fontFamily: "VarelaRound"),)),
        );
        return;
      }

      if (input <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte geben Sie einen gültigen Einsatz ein.', style: TextStyle(fontFamily: "VarelaRound"),)),
        );
        return;
      }




    });
  }



  Widget inputForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              SizedBox(height: 30),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: _controller1,
                      decoration: InputDecoration(labelText: 'Zahl von 1 - 70'),
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: _controller2,
                      decoration: InputDecoration(labelText: 'Zahl von 1 - 70'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Wie viel setzt du?',),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Submit', style: TextStyle(fontFamily: "VarelaRound"),),
                    ),
                    SizedBox(height: 20),

                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FirstPage()),
            );
          },
        ),
        title: const Text(
          'Chip Suche',
          style: TextStyle(fontSize: 30, fontFamily: ""),000
        ),
        actions: const [
          SizedBox(width: 20),
        ],
      ),
      body: inputForm(),
    );
  }
}