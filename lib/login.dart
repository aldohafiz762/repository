// ignore_for_file: unused_local_variable, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/models/login_model.dart';
import 'package:project_tugas_akhir_copy/services/login_service.dart';

class Login extends StatefulWidget {
  static const nameRoute = '/login';

  const Login(String d, {super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showpass = true;
  bool isAPIcallProcess = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late String? username;
  late String? password;
  bool isLoading = false;
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // UNTUK LEBAR TAMPILAN
    final mediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = mediaQuerywidth / 100;
    // UNTUK TINGGI TAMPILAN
    final mediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = mediaQueryheight / 100;
    // Mengetahui Orientasi Device
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          //BODY----------------------------------------------------------------------------------------------------------------
          body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: mediaQuerywidth * 0.05, vertical: blockVertical * 2.5),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                image: AssetImage("images/asset24.jpg"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, mygetstarted,
                            arguments: "from login");
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: mediaQueryheight * 0.05,
                        color: Colors.white,
                      )),
                ],
              ),
              Container(
                  height: mediaQueryheight * 0.35,
                  width: mediaQueryheight * 0.35,
                  child: Lottie.asset("lottie/login.json")),
              Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: blockVertical * 4,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mediaQueryheight * 0.01,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: mediaQuerywidth,
                  height: mediaQueryheight * 0.42,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      //blurEffect
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.13),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.5)
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  blockHorizontal * 2.5,
                                  blockHorizontal * 2.5,
                                  blockHorizontal * 1.25,
                                  blockHorizontal * 1.25),
                              child: Text(
                                "Input Username",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mediaQueryheight * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //EMAIL---------------------------------------------------------------------------
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: mediaQueryheight * 0.08,
                                width: mediaQuerywidth,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  border: Border.all(
                                    color: Colors.blueGrey.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.05),
                                      offset: Offset(2, 2),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: Username,
                                  style: TextStyle(
                                      fontSize: mediaQueryheight * 0.021),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    prefixIcon: Icon(
                                      Icons.person_rounded,
                                      size: mediaQueryheight * 0.035,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mediaQueryheight * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  blockHorizontal * 2.5,
                                  0,
                                  blockHorizontal * 1.25,
                                  blockHorizontal * 1.25),
                              child: Text(
                                "Input Password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mediaQueryheight * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Password----------------------------------------------------------------------------------------------------------------
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: mediaQueryheight * 0.08,
                                width: mediaQuerywidth,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  border: Border.all(
                                    color: Colors.blueGrey.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.05),
                                      offset: Offset(2, 2),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: Password,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                      fontSize: mediaQueryheight * 0.021),
                                  obscureText: _showpass,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: mediaQueryheight * 0.035,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showpass = !_showpass;
                                        });
                                      },
                                      icon: Icon(
                                        _showpass
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: mediaQueryheight * 0.035,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Button Login----------------------------------------------------------------------------------------------------------------
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: blockHorizontal * 1.25,
                                  vertical: blockVertical * 2),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: mediaQuerywidth,
                                  height: mediaQueryheight * 0.08,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromARGB(212, 2, 84, 122),
                                            Color.fromARGB(235, 14, 61, 99)
                                          ])),
                                  child: Material(
                                    type: MaterialType.canvas,
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      highlightColor:
                                          Color.fromARGB(255, 1, 56, 119),
                                      radius: 100,
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (Username.text.isNotEmpty ||
                                            Password.text.isNotEmpty) {
                                          LoginRequestModel model =
                                              LoginRequestModel(
                                            username: Username.text,
                                            password: Password.text,
                                          );
                                          LoginService.login(model)
                                              .then((value) => {
                                                    if (value)
                                                      {
                                                        setState(() {
                                                          isLoading = false;
                                                        }),
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                mytransisi,
                                                                arguments:
                                                                    "arg"),
                                                      }
                                                    else
                                                      {
                                                        setState(() {
                                                          isLoading = false;
                                                        }),
                                                        AwesomeDialog(
                                                          context: context,
                                                          dialogType:
                                                              DialogType.error,
                                                          animType: AnimType
                                                              .leftSlide,
                                                          title: "Error",
                                                          desc:
                                                              "Username or Password Incorrect !",
                                                          autoHide: Duration(
                                                              seconds: 2),
                                                        ).show()
                                                      }
                                                  });
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.leftSlide,
                                            title: "Error",
                                            desc:
                                                "Username or Password Incorrect !",
                                            autoHide: Duration(seconds: 2),
                                          ).show();
                                        }
                                      },
                                      child: Center(
                                          child: isLoading
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                      Text(
                                                        "Loading...",
                                                        style: TextStyle(
                                                            fontSize:
                                                                mediaQueryheight *
                                                                    0.028,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              blockHorizontal *
                                                                  10),
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    ])
                                              : Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      fontSize:
                                                          mediaQueryheight *
                                                              0.028,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: blockVertical * 1,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
