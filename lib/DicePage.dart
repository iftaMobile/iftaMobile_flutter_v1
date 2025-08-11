import 'package:flutter/material.dart';

import 'dice.dart';

class DicePage extends StatelessWidget {
  const DicePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child:
        DiceRoller(),

      ),
    );
  }
}