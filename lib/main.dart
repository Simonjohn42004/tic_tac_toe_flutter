import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/game_bloc.dart';
import 'package:tic_tac_toe/game_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(create: (context) => GameBloc(), child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Tic Tac Toe"), centerTitle: true),
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                      0.4, // 40% of screen height
                  width:
                      MediaQuery.of(context).size.width *
                      0.9, // takes up 90% of the screen width
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text(
                              "X",
                              style: GoogleFonts.balooDa2(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ElevatedButton(
                  onPressed: () {
                    // Reset logic here
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
