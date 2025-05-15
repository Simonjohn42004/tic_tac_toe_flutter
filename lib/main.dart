import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/app_constants.dart';
import 'package:tic_tac_toe/backend/game_data/flutter_web_socket_provider.dart';
import 'package:tic_tac_toe/backend/game_data/offline_provider.dart';
import 'package:tic_tac_toe/backend/web_socket/web_socket_client.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_bloc.dart';
import 'package:tic_tac_toe/views/connection_page_view.dart';
import 'package:tic_tac_toe/views/game_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      routes: {
        connectionPageRoute: (context) => GameView(),
      }, //TODO implement the connection page and replace it instead of game view
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "The Moving Tic Tac Toe",
              style: GoogleFonts.alkatra(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                final provider = OfflineGameDataProvider();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          create: (context) => ConnectionBloc(provider),
                          child: const ConnectionPage(),
                        ),
                  ),
                );
              },
              child: Text("Play Offline"),
            ),

            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                final provider = FlutterWebSocketProvider(client: WebSocketClient());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          create: (context) => ConnectionBloc(provider),
                          child: const ConnectionPage(),
                        ),
                  ),
                );
              },
              child: Text("Play Online"),
            ),
          ],
        ),
      ),
    );
  }
}
