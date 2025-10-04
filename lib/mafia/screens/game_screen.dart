import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maf/mafia/screens/role_showoff_screen.dart';
import 'package:maf/mafia/screens/start_screen.dart';
import 'package:maf/mafia/structure.dart';
import 'package:maf/main.dart';
import 'package:maf/widgets.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:stroke_text/stroke_text.dart';

class MyGameScreen extends StatefulWidget {
  const MyGameScreen({super.key, required this.title});

  final String title;

  @override
  State<MyGameScreen> createState() => _MyGameScreenState();
}

class _MyGameScreenState extends State<MyGameScreen> {

  final _defaultIconsSize = 64.0;
  double iconsSize = 64.0;
  bool isGenerated = false;
  
  FToast fToast = FToast();
  final nominateListener = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    iconsSize = _defaultIconsSize * interfaceScale;
    fToast.init(context);
  }

  void update() {
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    if (!isGenerated) {
      isGenerated = true;

      nominatedPlayers.clear();

      double radius = min(MediaQuery.of(context).size.height - AppBar().preferredSize.height * 2, MediaQuery.of(context).size.width) * 0.4;

      for (int i = 0; i < players.length; i++) {
        players[i].position = Offset(
          MediaQuery.of(context).size.width * 0.5 + cos(2 * pi * i / players.length + pi / 2) * radius,
          MediaQuery.of(context).size.height * 0.5 + sin(2 * pi * i / players.length + pi / 2) * radius - AppBar().preferredSize.height,
        );
      }
    }

    final ValueNotifier<bool> stateNotifier = ValueNotifier<bool>(false);

    StringBuffer nominatedPlayersString = StringBuffer();
    int totalExcludeLast = nominatedPlayers.length - 1;
    for (int i = 0; i < totalExcludeLast; i++) {
      nominatedPlayersString.write("${nominatedPlayers[i] + 1}\u00A0(${players[nominatedPlayers[i]].totalVotesAgainst}), ");
    }
    if (nominatedPlayers.isNotEmpty) {
      int unassignedVotes = players.length - countTotalVotes();
      // print("(${players[nominatedPlayers[totalExcludeLast]].totalVotesAgainst}, ${unassignedVotes})");
      nominatedPlayersString.write("${nominatedPlayers[totalExcludeLast] + 1}\u00A0(${unassignedVotes <= 0 ? players[nominatedPlayers[totalExcludeLast]].totalVotesAgainst : players[nominatedPlayers[totalExcludeLast]].totalVotesAgainst + unassignedVotes})");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.timer),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: WidgetBuildHelper.text("Вихід", color: Colors.white, size: 28),
                    content: WidgetBuildHelper.text("Ви впевнені, що хочете повернутися до вибору кількості гравців?\nПоточний розклад буде скинуто.", color: Colors.white),
                    actions: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                return Colors.transparent;
                              }),
                            ),
                            child: WidgetBuildHelper.text("Ні", color: Colors.white),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                    const MyStartScreen(title: "Mafia"),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                return Colors.transparent;
                              }),
                            ),
                            child: WidgetBuildHelper.text("Так", color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Text(widget.title),
          ],
        ),
      ),
      drawer: WidgetBuildHelper.buildDrawer(
        context,
        interfaceScale,
        (value) {
          setState(() {
            interfaceScale = value;
            iconsSize = _defaultIconsSize * interfaceScale;
          });
        }, () => setState(() {}),
        includeNominantsReset: true,
      ),
      endDrawer: WidgetBuildHelper.buildEndDrawer(context, stateNotifier),
      onEndDrawerChanged: (isOpen) {
        stateNotifier.value = isOpen;
      },
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Expanded(
            child: Stack(
            children: [
              Image.asset(
                "assets/background.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              for (int i = 0; i < players.length; i++) ...[
                Positioned(
                  left: players[i].position.dx - iconsSize * 0.5,
                  top: players[i].position.dy - iconsSize * 0.5,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        players[i].position += details.delta;
                      });
                    },
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (ctx) {
                          return ValueListenableBuilder<int>(
                            valueListenable: nominateListener,
                            builder: (_, value, __) {
                              return ListView(
                                shrinkWrap: true,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 6, 6, 6),
                                          border: Border.symmetric(
                                            horizontal: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          )
                                        ),
                                        child: Row(
                                          children: [
                                            WidgetBuildHelper.text("Гравець ${i + 1} ", color: Colors.white),
                                            Center(
                                              child: WidgetBuildHelper.text(getPlayerRoleName(players[i].role), color: Colors.white)
                                            ),
                                          ],
                                        )
                                      ),

                                      ListTile(
                                        leading: const Icon(Icons.person, color: Colors.white),
                                        title: WidgetBuildHelper.strokeText("Показати Роль", color: Colors.white, strokeColor: Colors.black),
                                        onTap: () {
                                            Navigator.pop(ctx);
                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                MyRoleScreen(title: "Mafia", role: players[i].role),
                                            ),
                                          );
                                        },
                                      ),

                                      ListTile(
                                        leading: const Icon(Icons.account_circle_outlined, color: Colors.white,),
                                        title: WidgetBuildHelper.strokeText("Змінити Роль", color: Colors.white, strokeColor: Colors.black),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                                            builder: (ctx) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.pacific), PlayerRole.pacific, update),
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.mafia), PlayerRole.mafia, update),
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.don), PlayerRole.don, update),
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.sheriff), PlayerRole.sheriff, update),
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.doctor), PlayerRole.doctor, update),
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.whore), PlayerRole.whore, update),
                                                  WidgetBuildHelper.playerRoleListTile(players[i], ctx, getPlayerRoleName(PlayerRole.maniac), PlayerRole.maniac, update),
                                                ],
                                              );
                                            }
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(players[i].isNominated ? Icons.flag_outlined : Icons.flag, color: Colors.white),
                                        title: WidgetBuildHelper.strokeText(players[i].isNominated ? "Зняти з номінації" : "Номінувати на виключення", color: players[i].isAlive ? Colors.white : Colors.grey, strokeColor: Colors.black),
                                        onTap: () {
                                          if (players[i].isAlive) {
                                            setState(() {
                                              players[i].isNominated = !players[i].isNominated;

                                              if (players[i].isNominated && !nominatedPlayers.contains(i)) {
                                                nominatedPlayers.add(i);
                                              }
                                              else if (!players[i].isNominated && nominatedPlayers.contains(i)) {
                                                nominatedPlayers.remove(i);
                                              }

                                              nominateListener.value++;
                                            });

                                            // Navigator.pop(ctx);
                                            WidgetBuildHelper.showToast(fToast, "Гравця ${i + 1} ${players[i].isNominated ? "було Номіновано" : "було знято з Номінації"}");
                                          }
                                        },
                                      ),
                                      if (players[i].isNominated) ... {
                                        Container(
                                          // padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          color: Colors.black26,
                                          width: double.infinity,
                                          child: ValueCounter(
                                            title: "Голосів за",
                                            allowAdd: (players.length - countTotalVotes() > 0),
                                            initialValue: players[i].totalVotesAgainst,
                                            onChanged: (v) {
                                              setState(() => players[i].totalVotesAgainst = v);
                                              nominateListener.value++;
                                            }
                                          ),
                                        ),
                                      },
                                      ListTile(
                                        leading: Icon(players[i].isAlive ? Icons.block : Icons.cached, color: Colors.white),
                                        title: WidgetBuildHelper.strokeText(players[i].isAlive ? "Вбити" : "Воскресити", color: Colors.white, strokeColor: Colors.black),
                                        onTap: () {
                                          setState(() {
                                            players[i].isAlive = !players[i].isAlive;
                                            if (!players[i].isAlive) {
                                              players[i].isNominated = false;
                                              players[i].totalVotesAgainst = 0;
                                              if (nominatedPlayers.contains(i)) {
                                                nominatedPlayers.remove(i);
                                              }
                                            }
                                          });

                                          Navigator.pop(ctx);
                                          WidgetBuildHelper.showToast(fToast, "Гравець ${i + 1} ${players[i].isAlive ? "був Воскрешений" : "був Вбитий"}");
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: _buildPlayer(i, players[i]),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (nominatedPlayers.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
            ),
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8 + MediaQuery.of(context).viewPadding.bottom),
                child: Text(
                  nominatedPlayersString.toString(),
                  style: TextStyle(fontSize: 28 * interfaceScale, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
          ),
      ]),
    );
  }

  Widget _buildPlayer(int index, Player player) { 
    return Column(
      children: [
        StrokeText(
          text: "${index + 1}",
          textStyle: TextStyle(
            fontSize: 16 * interfaceScale,
            color: player.isNominated ? Colors.amber : Colors.white
          ),
          strokeColor: Colors.black,
          strokeWidth: (3 * interfaceScale),
        ),
        Container(
          width: iconsSize,
          height: iconsSize,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Center(
                child: SimpleShadow(
                  color: Colors.white,
                  sigma: 2.0 * interfaceScale,
                  offset: Offset.zero,
                  child: Padding(
                    padding: EdgeInsets.all(4.0 * interfaceScale),
                    child: Image.asset(
                      getPlayerRoleImageAsset(player.role),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              if (!player.isAlive) ... {
                  Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: (iconsSize),
                ),
              }
              else if (player.isNominated && players[index].totalVotesAgainst > 0) ... [
                if (!nominatedPlayers.contains(index)) () {
                  nominatedPlayers.add(index);
                  return const SizedBox.shrink();
                }(),

                Stack(
                  children: [
                  if (players[index].totalVotesAgainst > 0)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24.0 * (interfaceScale * 0.5)),
                        ),
                        child: WidgetBuildHelper.strokeText(
                          "${players[index].totalVotesAgainst}",
                          size: 16 * interfaceScale,
                          padding: const EdgeInsets.all(0),
                          color: const Color.fromARGB(255, 255, 0, 0),
                          strokeColor: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  int countTotalVotes() {
    return nominatedPlayers.fold(0, (sum, e) => sum + players[e].totalVotesAgainst);
  }
}