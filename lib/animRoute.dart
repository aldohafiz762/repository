// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget page;
  BouncyPageRoute({required this.page})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.fastLinearToSlowEaseIn);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, animationTime) {
              return page;
            });
}
