// Gebaut von Marc

import 'package:flutter/material.dart';
import '/UeberIfta.dart';
import 'ChipSuche.dart';
import 'dart:math' as math;
import 'TattooSuche.dart';
import 'IdSuche.dart';
import 'TierRegistrierung.dart';

import 'storageHelper.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  final String sesid = 'dein_vorhandener_sesid_wert';

  @override
  void initState() {
    super.initState();
    _loadCoinsOnStartup();
  }

  Future<void> _loadCoinsOnStartup() async {
    await StorageHelper.loadCounter();
    setState(() {});
  }

  Widget _buildGameButton({
    required String imagePath,
    required String label,
    required double imageSize,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPressed,
            child: SizedBox(
              height: imageSize,
              width: imageSize,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6), // 👈 kleiner Abstand zum Text
          Text(
            label,
            style: const TextStyle(fontSize: 22), // Optional: kleinere Schrift
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IFTA Mobile', style: TextStyle(fontSize: 27, fontFamily: "VarelaRound")),
        toolbarHeight: 100,
        actions: <Widget>[
          IconButton(
            icon: SizedBox(
              height: 37,
              child: Image.asset('assets/images/Button6_200x200px.png'),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SizedBox(
              height: 42,
              child: Image.asset('assets/images/Button7_200x200px.png'),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 20),
        ],
      ),
      drawer: Builder(
        builder: (context) {
          final double drawerWidth = math.min(
            MediaQuery.of(context).size.width / 2,
            210,
          );



          return SizedBox(
            width: drawerWidth,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 120,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color(0xFF287233),
                      ),
                      child: const Text(
                        'Einstellungen',
                        style: TextStyle(fontSize: 23, fontFamily: "VarelaRound"),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('LOG IN', style: TextStyle(fontFamily: "VarelaRound")),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Coins', style: TextStyle(fontFamily: "VarelaRound")),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double imageSize = screenWidth * 0.38;

          return Column(
            children: [
              const Spacer(flex: 1), // 🧭 Platz oben
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 👈 added vertical padding
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 35,
                    childAspectRatio: 1.1,
                    children: [
                      // your buttons

                    _buildGameButton(
                      imagePath: 'assets/images/Button1_200x200px.png',
                      label: 'Chip Suche',
                      imageSize: imageSize,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChipSuche()),
                      ),
                    ),
                    _buildGameButton(
                      imagePath: 'assets/images/Button2_200x200px.png',
                      label: 'Tattoo Suche',
                      imageSize: imageSize,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TattooSuche()),
                      ),
                    ),
                    _buildGameButton(
                      imagePath: 'assets/images/Button3_200x200px.png',
                      label: 'ID Suche',
                      imageSize: imageSize,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IdSuche()),
                      ),
                    ),
                    _buildGameButton(
                      imagePath: 'assets/images/Button4_200x200px.png',
                      label: 'Kunden Daten',
                      imageSize: imageSize,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChipSuche()),
                      ),
                    ),
                    _buildGameButton(
                      imagePath: 'assets/images/Button5_200x200px.png',
                      label: 'Über Ifta',
                      imageSize: imageSize,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UeberPage()),
                      ),
                    ),
                    _buildGameButton(
                      imagePath: 'assets/images/Button5_200x200px.png',
                      label: 'Registrieren',
                      imageSize: imageSize,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TierRegistrierungPage(sesid: sesid)),
                        ),
                      ),
                  ],
                ),
              ),
              ),
              const Spacer(flex: 3), // 🧭 Platz unten
            ],
          );
        },
      ),


    );
  }
}