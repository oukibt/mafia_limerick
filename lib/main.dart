import 'package:flutter/material.dart';
import 'package:maf/mafia/screens/start_screen.dart';
import 'mafia/structure.dart';

List<Player> players = [];
List<int> nominatedPlayers = [];
double interfaceScale = 1.0;

//

final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      title: 'Flutter',
      home: const MyStartScreen(title: 'Mafia'),
    );
  }
}