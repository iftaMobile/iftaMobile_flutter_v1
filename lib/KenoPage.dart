import 'package:flutter/material.dart';
import 'Keno.dart';

class KenoPage extends StatelessWidget {
  const KenoPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child:
        Keno(),

      ),
    );
  }
}