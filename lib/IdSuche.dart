import 'dart:math';
import 'package:flutter/material.dart';

import 'appState.dart';
import 'FirstPage.dart';
import 'storageHelper.dart';

final randomizer = Random();

class IdSuche extends StatefulWidget {
  const IdSuche({super.key});

  @override
  State<IdSuche> createState() => _IdSucheState();
}

class _IdSucheState extends State<IdSuche> {
  // 1) EIGENE CONTROLLER FÜR JEDES FELD
  final TextEditingController _chipNrController  = TextEditingController();
  final TextEditingController _finder1Controller = TextEditingController();
  final TextEditingController _finder2Controller = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _submit() {
    final chipNr  = int.tryParse(_chipNrController.text) ?? 0;
    final finder1 = _finder1Controller.text.trim();
    final finder2 = _finder2Controller.text.trim();
    final comment = _commentController.text.trim();

    if (chipNr <= 0) {
      _showSnack('Bitte geben Sie eine gültige Chip-Nr. ein.');
      return;
    }

    // Beispiel-Validierung: wenn Finder-Nummern angegeben, müssen sie zwischen 1 und 70 liegen
    // bool finder1Valid = finder1.isEmpty || (int.tryParse(finder1) != null && int.parse(finder1) >= 1 && int.parse(finder1) <= 70);
    // bool finder2Valid = finder2.isEmpty || (int.tryParse(finder2) != null && int.parse(finder2) >= 1 && int.parse(finder2) <= 70);
    //
    // if (!finder1Val020id || !finder2Valid) {
    //   _showSnack('TelNr. Finder muss zwischen 1 und 70 liegen (oder leer bleiben).');
    //   return;
    // }

    // TODO: Hier deine Such-Logik einfügen (API-Call, lokal speichern, Navigation ...)
    _showSnack('Suche gestartet: Chip $chipNr');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: const TextStyle(fontFamily: "VarelaRound"))),
    );
  }

  Widget inputForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            children: [
              TextField(
                controller: _chipNrController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ifta ID'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _finder1Controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'TelNr. Finder (optional)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _finder2Controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'TelNr. Finder2 (optional)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Kommentar (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,  // grüne Hinter­grund­farbe
                  foregroundColor: Colors.green.shade800,  // weiße Schrift
                ),
                onPressed: _submit,
                child: const Text('Suchen', style: TextStyle(fontFamily: "VarelaRound")),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
        title: const Text('Chip Suche', style: TextStyle(fontSize: 30)),
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
        alignment: Alignment.topCenter,      // nur horizontal zentriert, oben angesetzt
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: inputForm(),                // das neu strukturierte Formular
        ),
      ),
    );
  }
}