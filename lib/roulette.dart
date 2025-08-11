import 'coins.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:online_casino/storageHelper.dart';
import 'appState.dart';
import 'FirstPage.dart';

class Roulette extends StatefulWidget {
  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  int currentDiceRoll = 0;
  String choice = "";
  bool isButtonActive = false;
  bool isSpin = false;
  int checkup = 1;
  bool inputCheck = false;


  final StreamController<int> selected = StreamController<int>();
  final List<String> items = [
    '0',
    '1',
    '0',
    '1',
    '0',
    '1',
    '0',
    '1',
  ];

  final TextEditingController _controller = TextEditingController();
  int input = 0;

  void checkInput(){
    if (choice == "" ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte wählen Sie eine Farbe', style: TextStyle(fontFamily: "VarelaRound"),)),
      );
      inputCheck = false;
      return;
    }

    if (input <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte geben Sie einen gültigen Einsatz ein und klicken anschließend auf Submit.', style: TextStyle(fontFamily: "VarelaRound"),)),
      );
      inputCheck = false;
      return;
    }
  }

  void _submit() {
    setState(() {
      input = int.tryParse(_controller.text) ?? 0;
      inputCheck =true;
    });
    checkInput();

  }

  String? selectedName;
  bool isSpinning = false;

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void _setCheckup_0() { //Verhindert dass die gewählte Zahl nach dem Würfeln nochmal gewexchselt werden kann
    setState(() {
      checkup = 0;
    });
  }
  void _setCheckup_1() {
    setState(() {
      checkup = 1;
    });
  }

  int color1 = 0;
  int color2 = 0;


  Widget chooseColor() {
    return
      Column(children: [
        Text("Wähle eine Farbe auf die du dein Geld setzt", style: TextStyle(fontFamily: "VarelaRound"),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:  BoxDecoration(
                  border: Border.all(color: Color(color1))
              ),
              child:IconButton(
                iconSize: 50,
                icon: Icon(Icons.circle, color: Color(0xFFd0cae4),),
                onPressed: () {
                  _setChoice("0");
                  color1 = 0xFF000000;
                  color2 =0;
                  _setCheckup_0();
                },
              ),
            ),
            Container(
              decoration:  BoxDecoration(
                  border: Border.all(color: Color(color2))
              ),
              child:IconButton(
                iconSize: 50,
                icon: Icon(Icons.circle, color: Color(0xFF6450a6),),
                onPressed: () {
                  _setChoice("1");
                  color2 = 0xFF000000;
                  color1 =0;
                  _setCheckup_0();
                },
              ),
            ),

          ],
        ),

      ],);
  }


  void _setChoice(String give) {
    setState(() {
      choice = give;
    });
  }


  Widget inputForm() {
    return

      Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  SizedBox(
                      width: 300,
                      child:
                      Column(children: [
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              labelText: 'Wie viel setzt du?',),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text('Submit', style: TextStyle(fontFamily: "VarelaRound"),),
                        ),
                        SizedBox(height: 20),
                      ]))
                ],
              ),
            )
          ]
      );
  }

  Widget cashIn() {
    final state = AppState();

    /*if (choice == "") {
      return Text("");
    } else if (input == 0) {
      return Text("");
    } else {*/

    return
      SizedBox(
          height: 50,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                isButtonActive
                    ? () {
                  //setColorBack();
                  setState(() {
                    if (selectedName == choice && checkup != 0) {
                      state.sharedCounter = state.sharedCounter + input * 2; }// Coins Counter erhöhen
                    isButtonActive = false; //Button deaktivieren, damit nur 1 mal Coins eingelöst werden können;
                    currentDiceRoll = 0;
                    StorageHelper.saveCounter();
                    isSpinning = false;
                  });
                } : null,


                child: const Text('Cash In', style: TextStyle(fontFamily: "VarelaRound"),),
              ),

            ],
          ));

  }




  void spinWheel() {
    checkInput();
    if(inputCheck == true) {
      if (isSpinning) return;
      final state = AppState();

      final index = Fortune.randomInt(0, items.length);
      _setCheckup_1();

      selected.add(index);
      setState(() {
        isSpinning = true;
        selectedName = null;
      });
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          selectedName = items[index];
          if (choice != selectedName) isSpinning = false;
          if (selectedName == choice) isButtonActive = true;
        });
      });
      setState(() {
        state.sharedCounter = state.sharedCounter - input;
        StorageHelper.saveCounter();
      });
    }
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FirstPage()),
            );
          },
        ),
        title: const Text('Roulette', style: TextStyle(fontSize: 30, fontFamily: "Pacifico"),),
        actions: <Widget>[
          Coins(),
          SizedBox(width: 20,)
        ],),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              height: 350,
              width: 400,
              child: FortuneWheel(

                selected: selected.stream,
                items: [
                  for (var it in items) FortuneItem(child: Text(it)),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: isSpinning ? null : spinWheel,
            child: Text(isSpinning ? 'Dreht...' : 'Drehen', style: TextStyle(fontFamily: "VarelaRound"),),//KI
          ),
          SizedBox(height: 20),
          cashIn(),
          //if (selectedName != null)
          //Text(
          //'Gewonnen: $selectedName',
          //style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //),
          chooseColor(),
          inputForm(),
        ],
      ),
    );
  }
}
