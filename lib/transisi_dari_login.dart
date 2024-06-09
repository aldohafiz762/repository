// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:shimmer/shimmer.dart';

class FromLogin extends StatefulWidget {
  static const nameRoute = '/fromLogin';

  const FromLogin(String at, {super.key});
  @override
  State<FromLogin> createState() => _FromLoginState();
}

class _FromLoginState extends State<FromLogin> {
  @override
  void initState() {
    super.initState();
    fromLogin();
  }

  //TIMER GANTI SCREEN----------------------------------------------------------------------------------------------------------------
  fromLogin() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () {
        Navigator.pushReplacementNamed(context, mydashboard,
            arguments: 'fromLogin');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = mediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final mediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = mediaQueryheight / 100;
    return Scaffold(
      body: Container(
        height: mediaQueryheight,
        width: mediaQuerywidth,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login Success!!!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: blockVertical * 3,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: blockVertical * 0.2,
              ),
              Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Text("Please Wait...",
                      style: TextStyle(
                          color: Colors.white, fontSize: blockVertical * 2))),
              SizedBox(
                height: blockVertical * 1,
              ),
              LinearPercentIndicator(
                width: mediaQuerywidth,
                lineHeight: blockVertical * 2,
                barRadius: Radius.circular(blockVertical * 2),
                percent: 1,
                progressColor: Color.fromARGB(255, 0, 134, 243),
                backgroundColor: Colors.blue.withOpacity(0.3),
                animation: true,
                animationDuration: 2500,
              )
            ],
          ),
        ),
      ),
    );
  }
}
