import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maf/mafia/screens/prepare_screen.dart';
import 'package:maf/main.dart';
import 'package:stroke_text/stroke_text.dart';

import 'mafia/structure.dart';

class RoleCounter extends StatefulWidget {
  final String title;
  final String previewImagePath;
  final int initialValue;
  final ValueChanged<int>? onChanged;
  final bool allowAdd;

  const RoleCounter({
    Key? key,
    required this.title,
    required this.previewImagePath,
    this.initialValue = 0,
    this.onChanged,
    this.allowAdd = true,
  }) : super(key: key);

  @override
  State<RoleCounter> createState() => _RoleCounterState();
}

class _RoleCounterState extends State<RoleCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  void _update(int delta) {
    setState(() => count = (count + delta).clamp(0, 999));
    widget.onChanged?.call(count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 6, right: 6),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 6.0),
            child: Image.asset(widget.previewImagePath, width: 64 * interfaceScale, height: 64 * interfaceScale),
          ),
          const SizedBox(width: 8),
          WidgetBuildHelper.text(widget.title, size: 24 * interfaceScale, weight: FontWeight.bold, color: Colors.white),
          const Spacer(),
          SizedBox(
            height: 54.0 * interfaceScale,
            width: 54.0 * interfaceScale,
            child: IconButton(
              icon: Image.asset(
                "assets/minus.png",
                fit: BoxFit.fill,
                color: count > 0 ? null : const Color.fromARGB(0, 158, 158, 158),
              ),
              onPressed: () => count > 0 ? _update(-1) : _update(0),
            ),
          ),
          WidgetBuildHelper.text("$count", size: 32 * interfaceScale, weight: FontWeight.bold, color: Colors.white),
          SizedBox(
            height: 54.0 * interfaceScale,
            width: 54.0 * interfaceScale,
            child: IconButton(
              icon: Image.asset(
                "assets/plus.png",
                fit: BoxFit.fill,
                color: widget.allowAdd ? null : const Color.fromARGB(0, 158, 158, 158),
              ),
              onPressed: () => widget.allowAdd ? _update(1) : _update(0),
            ),
          ),
        ],
      ),
    );
  }
}

//

class ValueCounter extends StatefulWidget {
  final String title;
  final int initialValue;
  final ValueChanged<int>? onChanged;
  final bool allowAdd;

  const ValueCounter({
    Key? key,
    required this.title,
    this.initialValue = 0,
    this.onChanged,
    this.allowAdd = true,
  }) : super(key: key);

  @override
  State<ValueCounter> createState() => _ValueCounterState();
}

class _ValueCounterState extends State<ValueCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  void _update(int delta) {
    setState(() => count = (count + delta).clamp(0, 999));
    widget.onChanged?.call(count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 6, right: 6),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          WidgetBuildHelper.text(widget.title, size: 24 * interfaceScale, weight: FontWeight.bold, color: Colors.white),
          const Spacer(),
          SizedBox(
            height: 54.0 * interfaceScale,
            width: 54.0 * interfaceScale,
            child: IconButton(
              icon: Image.asset("assets/minus.png", fit: BoxFit.fill),
              onPressed: () => _update(-1),
            ),
          ),
          WidgetBuildHelper.text("$count", size: 32 * interfaceScale, weight: FontWeight.bold, color: Colors.white),
          SizedBox(
            height: 54.0 * interfaceScale,
            width: 54.0 * interfaceScale,
            child: IconButton(
              icon: Image.asset(
                "assets/plus.png",
                fit: BoxFit.fill,
                color: widget.allowAdd ? null : const Color.fromARGB(0, 158, 158, 158),
              ),
              onPressed: () => widget.allowAdd ? _update(1) : _update(0),
            ),
          ),
        ],
      ),
    );
  }
}

//

class WidgetBuildHelper {

  static Container horizontalLine({Color color = Colors.black, double height = 3, EdgeInsets margin = const EdgeInsets.all(8)}) {
    return Container(
      width: double.infinity,
      height: height,
      color: color,
      margin: margin,
    );
  }

  static Widget text(String text, {EdgeInsets padding = const EdgeInsets.all(8.0), double size = 18.0,
    Color color = Colors.black, FontWeight weight = FontWeight.normal, bool shadows = false}) {
      
    return Container(
      padding: padding,
      child: Text(
        text, 
        style: TextStyle(
          color: color,
          fontSize: size,
          shadows: shadows ? [
            const Shadow(blurRadius: 10, color: Colors.black),
          ] : null,
        ),
      ),
    );
  }

  static Widget strokeText(String text, {EdgeInsets padding = const EdgeInsets.all(8.0), double size = 18.0, Color color = Colors.black,
    FontWeight weight = FontWeight.normal, Color strokeColor = Colors.white, double strokeWidth = 3, List<Shadow>? shadows}) {
      
    return Container(
      padding: padding,
      child: StrokeText(
        text: text, 
        textStyle: TextStyle(
          color: color,
          fontSize: size,
          shadows: shadows,
        ),
        strokeColor: strokeColor,
        strokeWidth: (strokeWidth * interfaceScale),
      ),
    );
  }

  static Widget playerRoleListTile(Player player, BuildContext ctx, String text, PlayerRole role, Function() updateCallback) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Image.asset(
          getPlayerRoleImageAsset(role),
          width: 64,
          height: 64,
        ),
      ),
      title: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black38,
        ),
        width: double.infinity,
        child: Center(
          child: WidgetBuildHelper.strokeText(
            text,
            color: getPlayerRoleColor(role),
            strokeColor: getPlayerRoleOutlineColor(role)
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: ctx,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: WidgetBuildHelper.text("Підтвердження", color: Colors.white, size: 28),
            content: WidgetBuildHelper.text("Ви впевнені, що хочете змінити роль гравця з ${getPlayerRoleName(player.role)} на ${getPlayerRoleName(role)}?", color: Colors.white),
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
                      player.role = role;
                      updateCallback.call();
                      Navigator.pop(ctx);
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
    );
  }

  static Drawer buildDrawer(BuildContext context,
    double interfaceScale, Function(double) onScaleChanged, Function() updateCallback, {bool includeNominantsReset = false}) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 145, 46, 46),
            ),
            child: Text(
              "Налаштування",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                color: const Color.fromARGB(255, 30, 30, 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 160.0,
              ),
              Column(
                children: [
                  ListTile(
                    title: const Text(
                      "Масштаб інтерфейсу",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    subtitle: Slider(
                      value: interfaceScale,
                      min: 0.7,
                      max: 1.2,
                      divisions: 25,
                      activeColor: Colors.white,
                      inactiveColor: Colors.red,
                      label: interfaceScale.toStringAsFixed(2),
                      onChanged: onScaleChanged,
                    ),
                  ),
                  if (includeNominantsReset)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Colors.black,
                      ),
                      child: TextButton(
                        child: WidgetBuildHelper.text("Скинути номінантів", color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.black,
                              title: WidgetBuildHelper.text("Скидання", color: Colors.white, size: 28),
                              content: WidgetBuildHelper.text("Ви впевнені, що хочете скинути всіх номінованих гравців?", color: Colors.white),
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

                                        nominatedPlayers.clear();
                                        for (int i = 0; i < players.length; i++) {
                                          players[i].isNominated = false;
                                          players[i].totalVotesAgainst = 0;
                                        }

                                        updateCallback.call();
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
                    ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  static void showToast(FToast fToast, String text, {Color color = Colors.yellowAccent, Duration duration = const Duration(milliseconds: 3500)}) {

    fToast.removeCustomToast();
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: const Color.fromARGB(120, 80, 80, 80),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, color: Colors.white),
            const SizedBox(width: 12.0),
            WidgetBuildHelper.strokeText(text, color: color, strokeColor: Colors.black),
          ],
        ),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: duration,
      ignorePointer: true,
    );
  }
  
  static bool _isEndDrawerMounted = true;
  static int timerInitialSeconds = 30;

  static List<Duration> timerPresets = [
    const Duration(seconds: 30),
    const Duration(seconds: 60),
  ];

static Drawer buildEndDrawer(BuildContext context, ValueNotifier<bool> onMountedStateNotifier) {
  final timerState = TimerState();

  onMountedStateNotifier.addListener(() {
    _isEndDrawerMounted = onMountedStateNotifier.value;
    if (!_isEndDrawerMounted) {
      timerState.stopTimer(null, () => _isEndDrawerMounted);
    } else {
      timerState.seconds = timerInitialSeconds;
    }
  });

  return Drawer(
    child: StatefulBuilder(
      builder: (context, setState) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Таймер',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              color: (timerState.isRunning && timerState.seconds <= 7 && timerState.seconds >= 0 && timerState.seconds % 2 == 1) ? const Color.fromARGB(255, 130, 30, 30) : const Color.fromARGB(255, 30, 30, 30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 160.0,
              child: Column(
                children: [
                    Row(
                      children: [
                        for (int i = 0; i < timerPresets.length; i++) ... [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                color: Colors.black,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (!timerState.isRunning) {
                                    timerState.setTime(timerPresets[i].inSeconds, setState, () => _isEndDrawerMounted);
                                    timerInitialSeconds = timerPresets[i].inSeconds;
                                  }
                                },
                                child: WidgetBuildHelper.text(
                                  TimerState.formatTime(timerPresets[i].inSeconds),
                                  color: timerState.isRunning ? Colors.blueGrey : Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  Text(
                    TimerState.formatTime(timerState.seconds),
                    style: TextStyle(
                      color: timerState.seconds < 0 ? Colors.red : Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.black,
                          ),
                          child: IconButton(
                            onPressed: () {
                              timerState.adjustTime(-5, setState, () => _isEndDrawerMounted);
                              if (!timerState.isRunning) timerInitialSeconds -= 5;
                            },
                            icon: const Icon(Icons.remove_circle, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.all(12),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.black,
                          ),
                          child: IconButton(
                            onPressed: () {
                              timerState.adjustTime(5, setState, () => _isEndDrawerMounted);
                              if (!timerState.isRunning) timerInitialSeconds += 5;
                            },
                            icon: const Icon(Icons.add_circle, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.all(12),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (!timerState.isRunning) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Colors.black,
                      ),
                      child: IconButton(
                      onPressed: () => timerState.startTimer(setState, () => _isEndDrawerMounted),
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                        iconSize: 32,
                      ),
                    ),
                  ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            timerState.resetTimer(setState, () => _isEndDrawerMounted);
                            timerState.seconds = timerInitialSeconds;
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.all(12),
                            shape: const CircleBorder(),
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
      },
    ),
  );
}
}

//

class TimerState {
  int seconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  bool get isRunning => _isRunning;

  void startTimer(StateSetter? update, bool Function() isMounted) {
    if (!_isRunning && isMounted()) {
      _isRunning = true;
      update!(() {});
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (isMounted()) {
        seconds--;
          update(() {});
        }
      });
    }
  }

  void stopTimer(StateSetter? update, bool Function() isMounted) {
    _isRunning = false;
    _timer?.cancel();

    if (isMounted()) {
      update!(() {});
    }
  }

  void resetTimer(StateSetter? update, bool Function() isMounted) {
    _isRunning = false;
    _timer?.cancel();
    if (isMounted()) {
      seconds = 0;
      update!(() {});
    }
  }

  void adjustTime(int delta, StateSetter? update, bool Function() isMounted) {
    if (isMounted()) {
      seconds += delta;
      update!(() {});
    }
  }

  void setTime(int newTime, StateSetter? update, bool Function() isMounted) {
    if (isMounted()) {
      seconds = newTime;
      update!(() {});
    }
  }

  static String formatTime(int seconds) {
    int absSeconds = seconds.abs();
    int minutes = absSeconds ~/ 60;
    int secs = absSeconds % 60;
    String sign = seconds < 0 ? '-' : '';
    return '$sign${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _timer?.cancel();
  }
}

//

String getPlayerRoleImageAsset(PlayerRole role) {
  switch (role) {
    case PlayerRole.pacific: return "assets/pacific.png";
    case PlayerRole.mafia: return "assets/mafia.png";
    case PlayerRole.don: return "assets/don.png";
    case PlayerRole.sheriff: return "assets/sheriff.png";
    case PlayerRole.whore: return "assets/whore.png";
    case PlayerRole.doctor: return "assets/doctor.png";
    case PlayerRole.maniac: return "assets/maniac.png";
    default: return "assets/pacific.png";
  }
}

Color getPlayerRoleColor(PlayerRole role) {
  switch (role) {
    case PlayerRole.pacific: return Colors.white;
    case PlayerRole.mafia: return const Color.fromARGB(255, 168, 36, 27);
    case PlayerRole.don: return Colors.black;
    case PlayerRole.sheriff: return Colors.yellow;
    case PlayerRole.whore: return const Color.fromARGB(255, 224, 34, 98);
    case PlayerRole.doctor: return const Color.fromARGB(255, 255, 0, 0);
    case PlayerRole.maniac: return const Color.fromARGB(255, 167, 83, 83);
    default: return Colors.white;
  }
}

Color getPlayerRoleOutlineColor(PlayerRole role) {
  switch (role) {
    case PlayerRole.pacific: return Colors.black;
    case PlayerRole.mafia: return Colors.black;
    case PlayerRole.don: return Colors.white;
    case PlayerRole.sheriff: return Colors.black;
    case PlayerRole.whore: return Colors.black;
    case PlayerRole.doctor: return Colors.black;
    case PlayerRole.maniac: return Colors.black;
    default: return Colors.white;
  }
}

String getPlayerRoleName(PlayerRole role) {
  switch (role) {
    case PlayerRole.pacific: return "Мирний";
    case PlayerRole.mafia: return "Мафія";
    case PlayerRole.don: return "Дон";
    case PlayerRole.sheriff: return "Шериф";
    case PlayerRole.whore: return "Лярва";
    case PlayerRole.doctor: return "Лікар";
    case PlayerRole.maniac: return "Маньяк";
    default: return "Unknown";
  }
}