import 'dart:math';
import 'package:flutter/material.dart';
import 'appState.dart';
import 'FirstPage.dart';
import 'storageHelper.dart';

final randomizer = Random();

class TattooSuche extends StatefulWidget {
  const TattooSuche({Key? key}) : super(key: key);

  @override
  State<TattooSuche> createState() => _TattooSucheState();
}

class _TattooSucheState extends State<TattooSuche> {
  // getrennte Controller für linkes und rechtes Ohr
  final TextEditingController _leftEarController  = TextEditingController();
  final TextEditingController _rightEarController = TextEditingController();

  final TextEditingController _finder1Controller  = TextEditingController();
  final TextEditingController _finder2Controller  = TextEditingController();
  final TextEditingController _commentController  = TextEditingController();

  @override
  void dispose() {
    // niemals vergessen: freigeben
    _leftEarController.dispose();
    _rightEarController.dispose();
    _finder1Controller.dispose();
    _finder2Controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    final int leftChip  = int.tryParse(_leftEarController.text.trim())  ?? 0;
    final int rightChip = int.tryParse(_rightEarController.text.trim()) ?? 0;
    final String finder1 = _finder1Controller.text.trim();
    final String finder2 = _finder2Controller.text.trim();
    final String comment = _commentController.text.trim();

    // Prüfen: beide Chips sind ungültig?
    if (leftChip <= 0 && rightChip <= 0) {
      _showSnack('Bitte mindestens eine gültige Nummer für eines der Ohren eingeben.');
      return;
    }



    // Beispiel: Nur gefüllte Felder weiterverarbeiten
    final List<int> chips = [];
    if (leftChip > 0)  chips.add(leftChip);
    if (rightChip > 0) chips.add(rightChip);

    // TODO: Hier deine Such-Logik mit `chips`, `finder1`, `finder2`, `comment`
    _showSnack('Suche gestartet für Chips: ${chips.join(', ')}');
  }


  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: "VarelaRound")),
      ),
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _leftEarController,        // links
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Linkes Ohr'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _rightEarController,       // rechts
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Rechtes Ohr'),
                    ),
                  ),
                ],
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
                decoration: const InputDecoration(labelText: 'Kommentar (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,  // grüne Hinter­grund­farbe
                  foregroundColor: Colors.green.shade800,  // weiße Schrift
                ),
                child: const Text(
                  'Suchen',
                  style: TextStyle(fontFamily: "VarelaRound"),
                ),
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
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: inputForm(),
        ),
      ),
    );
  }
}