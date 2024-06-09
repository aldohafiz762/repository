// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:project_tugas_akhir_copy/constant.dart';

class Splash extends StatefulWidget {
  static const nameRoute = '/splash';

  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    splash();
  }

  //TIMER GANTI SCREEN----------------------------------------------------------------------------------------------------------------
  splash() async {
    var duration = const Duration(seconds: 2);
    return Timer(
      duration,
      () {
        Navigator.pushReplacementNamed(context, mygetstarted,
            arguments: 'splash');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      //CONTENT SPLASHSCREEN----------------------------------------------------------------------------------------------------------------
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 5, 8, 185),
                Color.fromARGB(255, 2, 71, 83),
              ]),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.computer_rounded,
                      size: MediaQueryheight * 0.15,
                      shadows: [
                        Shadow(
                          offset: Offset(5, 2),
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                      color: Colors.white.withAlpha(250),
                    ),
                  ],
                ),
                Text(
                  "PRODUCTION MONITORING SYSTEM",
                  style: TextStyle(
                    fontSize: MediaQueryheight * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withAlpha(250),
                    shadows: [
                      Shadow(
                        offset: Offset(1, 5),
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
