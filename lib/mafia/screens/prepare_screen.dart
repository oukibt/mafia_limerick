import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maf/mafia/screens/game_screen.dart';
import 'package:maf/mafia/structure.dart';
import 'package:maf/main.dart';
import 'package:maf/widgets.dart';

// ignore: must_be_immutable
class MyPrepareScreen extends StatefulWidget {
  MyPrepareScreen({super.key, required this.title, required this.maxPlayers}) {
    maxPlayers = max(maxPlayers, 4);
  }

  final String title;
  int maxPlayers;

  @override
  State<MyPrepareScreen> createState() => _MyPrepareScreenState();
}

class RoleInfo {
  String title;
  PlayerRole role;
  int count;

  RoleInfo(this.title, this.role, this.count);
}

class _MyPrepareScreenState extends State<MyPrepareScreen> {

  final maniacRequiredPlayers = 15;
  List<RoleInfo> playersByRoles = [];

  @override
  void initState() {

    if (widget.maxPlayers > 4) {
      
      int freePlaces = (widget.maxPlayers >= maniacRequiredPlayers ? widget.maxPlayers - 5 : widget.maxPlayers - 4);
      int pacificPlayers = (freePlaces * 0.6).ceil();
      int mafiaPlayers = freePlaces - pacificPlayers;

      playersByRoles.add(RoleInfo("Мирний", PlayerRole.pacific, pacificPlayers));
      playersByRoles.add(RoleInfo("Дон", PlayerRole.don, 1));
      playersByRoles.add(RoleInfo("Мафія", PlayerRole.mafia, mafiaPlayers));
      playersByRoles.add(RoleInfo("Шериф", PlayerRole.sheriff, 1));
      playersByRoles.add(RoleInfo("Лікар", PlayerRole.doctor, 1));
      playersByRoles.add(RoleInfo("Лярва", PlayerRole.whore, 1));
      playersByRoles.add(RoleInfo("Маньяк", PlayerRole.maniac, (widget.maxPlayers >= maniacRequiredPlayers) ? 1 : 0));
    }
    else {
      playersByRoles.add(RoleInfo("Мирний", PlayerRole.pacific, 0));
      playersByRoles.add(RoleInfo("Дон", PlayerRole.don, 1));
      playersByRoles.add(RoleInfo("Мафія", PlayerRole.mafia, 0));
      playersByRoles.add(RoleInfo("Шериф", PlayerRole.sheriff, 1));
      playersByRoles.add(RoleInfo("Лікар", PlayerRole.doctor, 1));
      playersByRoles.add(RoleInfo("Лярва", PlayerRole.whore, 1));
      playersByRoles.add(RoleInfo("Маньяк", PlayerRole.maniac, 0));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(widget.title),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: WidgetBuildHelper.strokeText(
                "Всього: ${playersByRoles.fold(0, (sum, e) => sum + e.count)} / ${widget.maxPlayers}",
                color: Colors.white,
                strokeColor: Colors.black,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
      drawer: WidgetBuildHelper.buildDrawer(
        context,
        interfaceScale,
        (value) {
          setState(() {
            interfaceScale = value;
          });
        }, () => setState(() {}),
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/background.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (int i = 0; i < playersByRoles.length; i++) ... [
                      RoleCounter(
                        title: playersByRoles[i].title,
                        previewImagePath: getPlayerRoleImageAsset(playersByRoles[i].role),
                        initialValue: playersByRoles[i].count,
                        onChanged: (v) => setState(() => playersByRoles[i].count = v),
                        allowAdd: playersByRoles.fold(0, (sum, e) => sum + e.count) < widget.maxPlayers,
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {

                    nominatedPlayers.clear();
                    players.clear();

                    for (int role = 0; role < playersByRoles.length; role++) {
                      for (int index = 0; index < playersByRoles[role].count; index++) {

                        Player player = Player();
                        player.role = playersByRoles[role].role;

                        players.add(player);
                      }
                    }

                    players.shuffle(Random());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                          const MyGameScreen(title: "Mafia"),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Підтвердити",
                      style: TextStyle(fontSize: 20 * interfaceScale, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
