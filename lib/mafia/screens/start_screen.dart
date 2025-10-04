import 'package:flutter/material.dart';
import 'package:maf/mafia/screens/prepare_screen.dart';
import 'package:maf/mafia/structure.dart';
import 'package:maf/main.dart';
import 'package:maf/widgets.dart';

class MyStartScreen extends StatefulWidget {
  const MyStartScreen({super.key, required this.title});

  final String title;

  @override
  State<MyStartScreen> createState() => _MyStartScreenState();
}

class RoleInfo {
  String title;
  PlayerRole role;
  int count;

  RoleInfo(this.title, this.role, this.count);
}

class _MyStartScreenState extends State<MyStartScreen> {

  int maxPlayers = 13;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        title: Text(widget.title),
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
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      RoleCounter(
                        title: "Всього",
                        previewImagePath: getPlayerRoleImageAsset(PlayerRole.pacific),
                        initialValue: maxPlayers,
                        onChanged: (v) => setState(() => maxPlayers = v),
                      ),
                    ],
                  ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                          MyPrepareScreen(title: "Mafia", maxPlayers: maxPlayers),
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
