import 'dart:ui';

enum PlayerRole {
  pacific,
  mafia,
  maniac,
  don,
  sheriff,
  whore,
  doctor,
}

class Player {
  Offset position = Offset.zero;
  bool isAlive = true;
  bool isNominated = false;
  int totalVotesAgainst = 0;
  PlayerRole role = PlayerRole.pacific;
}