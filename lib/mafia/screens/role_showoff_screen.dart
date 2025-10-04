import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:maf/mafia/structure.dart';
import 'package:maf/main.dart';
import 'package:maf/widgets.dart';
import 'package:simple_shadow/simple_shadow.dart';

class MyRoleScreen extends StatefulWidget {
  const MyRoleScreen({super.key, required this.title, required this.role});

  final String title;
  final PlayerRole role;

  @override
  State<MyRoleScreen> createState() => _MyRoleScreenState();
}

class _MyRoleScreenState extends State<MyRoleScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          ],
        ),
      ),      
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            "assets/background.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: AutoSizeText(
                    getPlayerRoleName(widget.role),
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.height * 0.1).ceilToDouble(),
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 16.0,
                        ),
                      ]
                    ),
                    minFontSize: 8,
                    maxFontSize: (MediaQuery.of(context).size.height * 0.1).ceilToDouble(),
                  ),
                ),
                const Spacer(),
                SimpleShadow(
                  opacity: 1.0,
                  color: Colors.white,
                  offset: const Offset(0, 0),
                  sigma: 7,
                  child: Container(
                    clipBehavior: Clip.none,
                    margin: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      getPlayerRoleImageAsset(widget.role),
                      width: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.8 - AppBar().preferredSize.height - 48),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
