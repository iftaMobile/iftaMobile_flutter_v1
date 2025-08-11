import 'dart:math';
import 'package:flutter/material.dart';
import 'package:online_casino/coins.dart';
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
  int currentDiceRoll = 0;
  int choice = 0;
  bool isButtonActiveCash = false;
  bool isButtonActiveRole = true;
  int checkup =1;
  bool inputCheck = false;

  Color _iconColor1 = Colors.black;
  Color _iconColor2 = Colors.black;
  Color _iconColor3 = Colors.black;
  Color _iconColor4 = Colors.black;
  Color _iconColor5 = Colors.black;
  Color _iconColor6 = Colors.black;


  final TextEditingController _controller = TextEditingController();
  int input = 0;

  void _submit() { //Verarbeitet die eingaben
    setState(() {
      input = int.tryParse(_controller.text) ?? 0;
      checkInput();
    });
  }

  void checkInput(){ // Checkt ob die Inpit Forms ausgefüllt dsind und gibt dem USer Rückmeldung was fehlt
    setState(() {
      if (choice == 0 && input<= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte wählen sie eine Zahl auf die Sie setzen und geben Sie einen gültigen Einsatz an', style: TextStyle(fontFamily: "VarelaRound"),)),
        );
        return;
      }

      if (choice == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte wählen sie eine Zahl auf die Sie setzen', style: TextStyle(fontFamily: "VarelaRound"),)),
        );
        return;
      }

      if (input <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte geben Sie einen gültigen Einsatz ein.', style: TextStyle(fontFamily: "VarelaRound"),)),
        );
        return;
      }
      if (choice != 0 && input >= 0){
        inputCheck =true;
      }
    });
  }


  /*Widget check() {
    if (input == 0) {
      return Text("du must Geld setzen");
    } else {
      return Text("du hast $input gesetzt");
    }
  }*/
  void randomize(){
    setState(() {
      currentDiceRoll = randomizer.nextInt(3) +1;//erstellt Zufallszahl 1-6 für den Würfel
    });
  }

  void reduceCoins(){
    final state = AppState();
    setState(() {
      state.sharedCounter = state.sharedCounter - input;//zieht einsatz voM Vermögen ab
    });

  }

  void setCashTrue(){
    setState(() {
      isButtonActiveCash = true;//Aktiviert Cash IN Button
    });
  }

  void setRoleFalse(){
    setState(() {
      isButtonActiveRole = false;// Deaktiviert Role Dice Button
    });
  }

  bool check(){
    if (currentDiceRoll == choice && checkup != 0){
      return true;
    }else{
      return false;
    }
  }

  void roleDice() { // erstellt Zufallszahl 1-6 für den Würfel und zieht einsatz voM Vermögen ab

    checkInput();
    if (input != 0) {
      if (inputCheck) {
        setState(() {
          randomize();
          reduceCoins();
          StorageHelper.saveCounter(); // persistente Datenspeicherung
          if (check()){
            setCashTrue();
            setRoleFalse();
          }
        });
        _setCheckup_1();

      }
    }
  }


  Widget show() {
    if (currentDiceRoll == 0) {
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice5.png'));//Startwert
    }else{
      return SizedBox(
        height: 200, child: Image.asset('assets/images/dice$currentDiceRoll.png'));// schönere Lösung
    }
   /* if (currentDiceRoll == 1) {//Alte Lösung (unschön)
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice$currentDiceRoll.png'));
    }
    if (currentDiceRoll == 2) {
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice2.png'));
    }
    if (currentDiceRoll == 3) {
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice3.png'));
    }
    if (currentDiceRoll == 4) {
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice4.png'));
    }
    if (currentDiceRoll == 5) {
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice5.png'));
    } else {
      return SizedBox(
          height: 200, child: Image.asset('assets/images/dice6.png'));
    }*/
  }

  Widget cashIn() {
    final state = AppState();


        return
          SizedBox(
              height: 50,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isButtonActiveCash
                        ? () {
                      setState(() {
                        StorageHelper.saveCounter();
                        state.sharedCounter = state.sharedCounter +
                            input * 6; // Coins Counter erhöhen
                        isButtonActiveCash = false; //Button deaktivieren, damit nur 1 mal Coins eingelöst werden können;
                        currentDiceRoll = 0;
                        isButtonActiveRole = true;
                      });
                    } : null,

                    child: const Text('Cash In', style: TextStyle(fontFamily: "VarelaRound"),),
                  ),

                ],
              ));

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
                  SizedBox(height: 30,),
                  diceButtons(),
                  SizedBox(height: 30,),
                  SizedBox(
                      width: 300,
                      child:
                      Column(children: [
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              labelText: 'Wie viel setzt du?', ),
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

  void setColorBack() {
    setState(() {
      _iconColor1 = Colors.black;
      _iconColor2 = Colors.black;
      _iconColor3 = Colors.black;
      _iconColor4 = Colors.black;
      _iconColor5 = Colors.black;
      _iconColor6 = Colors.black;
    });
  }


  Widget diceButtons() {
    return
      Column(children: [
        Text("Wähle eine Zahl auf die du dein Geld setzt", style: TextStyle(fontFamily: "VarelaRound"),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: SizedBox(height: 45,
                  child: Image.asset(
                      'assets/images/dice1.png', color: _iconColor1)),
              onPressed: () {
                _setChoice(1);
                _setCheckup_0();
                setState(() {
                  _iconColor1 = Colors.grey;

                  _iconColor2 = Colors.black;
                  _iconColor3 = Colors.black;
                  _iconColor4 = Colors.black;
                  _iconColor5 = Colors.black;
                  _iconColor6 = Colors.black;
                });
              },
            ),
            IconButton(
              icon: SizedBox(height: 45,
                  child: Image.asset(
                      'assets/images/dice2.png', color: _iconColor2)),
              onPressed: () {
                _setChoice(2);
                _setCheckup_0();
                setState(() {
                  _iconColor2 = Colors.grey;

                  _iconColor1 = Colors.black;
                  _iconColor3 = Colors.black;
                  _iconColor4 = Colors.black;
                  _iconColor5 = Colors.black;
                  _iconColor6 = Colors.black;
                });
              },
            ),
            IconButton(
              icon: SizedBox(height: 45,
                  child: Image.asset(
                      'assets/images/dice3.png', color: _iconColor3)),
              onPressed: () {
                _setChoice(3);
                _setCheckup_0();
                setState(() {
                  _iconColor3 = Colors.grey;

                  _iconColor1 = Colors.black;
                  _iconColor2 = Colors.black;
                  _iconColor4 = Colors.black;
                  _iconColor5 = Colors.black;
                  _iconColor6 = Colors.black;
                });
              },
            ),
            IconButton(
              icon: SizedBox(height: 45,
                child: Image.asset(
                    'assets/images/dice4.png', color: _iconColor4),),
              onPressed: () {
                _setChoice(4);
                _setCheckup_0();
                setState(() {
                  _iconColor4 = Colors.grey;

                  _iconColor1 = Colors.black;
                  _iconColor2 = Colors.black;
                  _iconColor3 = Colors.black;
                  _iconColor5 = Colors.black;
                  _iconColor6 = Colors.black;
                });
              },
            ),
            IconButton(
              icon: SizedBox(height: 45,
                  child: Image.asset(
                      'assets/images/dice5.png', color: _iconColor5)),
              onPressed: () {
                _setChoice(5);
                _setCheckup_0();
                setState(() {
                  _iconColor5 = Colors.grey;

                  _iconColor1 = Colors.black;
                  _iconColor2 = Colors.black;
                  _iconColor3 = Colors.black;
                  _iconColor4 = Colors.black;
                  _iconColor6 = Colors.black;
                });
              },
            ),
            IconButton(
              icon: SizedBox(height: 45,
                  child: Image.asset(
                      'assets/images/dice6.png', color: _iconColor6)),
              onPressed: () {
                _setChoice(6);
                _setCheckup_0();
                setState(() {
                  _iconColor6 = Colors.grey;

                  _iconColor1 = Colors.black;
                  _iconColor2 = Colors.black;
                  _iconColor3 = Colors.black;
                  _iconColor4 = Colors.black;
                  _iconColor5 = Colors.black;
                });
              },

            ),

          ],
        ),

      ],);
  }

  void _setChoice(int input) {
    setState(() {
      choice = input;
    });
  }

  void _setCheckup_0() { //Verhindert dass die gewählte Zahl nach dem Würfeln nochmal gewechselt werden kann
    setState(() {
      checkup = 0;
    });
  }
  void _setCheckup_1() {
    setState(() {
      checkup = 1;
    });
  }




  @override
  Widget build(BuildContext context) {
    final state = AppState();

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
          title: const Text('Würfeln', style: TextStyle(fontSize: 30, fontFamily: "Pacifico"),),
          actions: <Widget>[
            Coins(),
            SizedBox(width: 20,)
          ],),
        body:
        Column(
            children: [
              SizedBox(height: 60,),
//check(),
              show(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isButtonActiveRole
                    ? () {
                  roleDice();
                  //setColorBack();
                  setState(() {
                    StorageHelper.saveCounter();
                  });

                } : null,

                child: const Text('Role Dice', style: TextStyle(fontFamily: "VarelaRound"),),
              ),
//Text('Current number = $currentDiceRoll!'),
              cashIn(),
              inputForm(),
//Text("${choice}"),
            ]
        )

    );
  }
}
