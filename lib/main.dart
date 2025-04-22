import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Column(
          children: [
            // creating the player score row
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text("Player 1"),
                          SizedBox(height: 5),
                          const Text("Score"),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text("Player 1"),
                          SizedBox(height: 5),
                          const Text("Score"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // creating a text box for showing the current state of the game
            Text("Players current state"),

            SizedBox(height: 20),
            //creating the play area for the game
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (row) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (col) {
                      String buttonId = "$row$col";
                      return TextButton(
                        onPressed: () {
                          devtools.log(
                            "You clicked the button at position $buttonId and its state is ${buttonIds[buttonId]}",
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(),
                          side: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Text(""),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                //TODO implement the restart button for the game
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green.shade200,
              ),
              child: const Text(
                "Restart Game",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                //TODO implement the Clear score and restart button for the game
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green.shade200,
              ),
              child: const Text(
                "Restart Match",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final buttonIds = <String, int>{
  "00": 0,
  "01": 0,
  "02": 0,
  "10": 0,
  "11": 0,
  "12": 0,
  "20": 0,
  "21": 0,
  "22": 0,
};
