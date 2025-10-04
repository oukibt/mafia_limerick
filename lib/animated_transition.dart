import 'package:flutter/material.dart';

class AnimatedTransition {

  AnimatedTransition(BuildContext context, Offset offset, Widget TranslateTo, {bool showAd = true})
  {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TranslateTo,

        transitionsBuilder: (context, animation, secondaryAnimation, child)
        {
          const end = Offset.zero;
          final tween = Tween(begin: offset, end: end);
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}


class Pair<T1, T2> {
  T1 item1;
  T2 item2;

  Pair(this.item1, this.item2);
}