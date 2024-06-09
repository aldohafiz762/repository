// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:project_tugas_akhir_copy/services/quality_service.dart';
// import 'package:project_tugas_akhir_copy/services/availability_service.dart';
import 'package:project_tugas_akhir_copy/services/oee_service.dart';
// import 'package:project_tugas_akhir_copy/services/plant_status.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/status_service.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
// import 'package:project_tugas_akhir_copy/drawer.dart';
import 'package:project_tugas_akhir_copy/models/status_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Dashboard extends StatefulWidget {
  static const nameRoute = '/dashboard';

  const Dashboard(String b, {super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Timer timer;
  // int? stateA1;

  //AVAILABILITY STATE
  // GetAvailability getAvaiState = GetAvailability();
  // Future<void> avaiState() async {
  //   getAvaiState.getState(1).then((value) {
  //     setState(() {
  //       stateA1 = value!;
  //     });
  //   });
  // }

  //PRODUCTION
  StreamController<List> streamProd = StreamController.broadcast();
  List<DashQuality> qList = [];
  QualityDash quality = QualityDash();
  Future<void> qualityData() async {
    qList = await quality.dashQualityM();
    streamProd.add(qList);
  }

  //PRODUCTION
  StreamController<List> streamOEE = StreamController.broadcast();
  List<OEEdashModel> oeeList = [];
  GetOEE OEE = GetOEE();
  Future<void> OEEData() async {
    oeeList = await OEE.dashOEE();
    streamOEE.add(oeeList);
  }

  // STREAMCONTROLLER MESIN
  // StreamController<List> streamStatusM1 = StreamController.broadcast();
  // List<Status1Model> statusList = [];
  // GetStatusM1 statusState = GetStatusM1();
  // Future<void> getStatus() async {
  //   statusList = await GetStatusM1.readStatM1();
  //   streamStatusM1.add(statusList);
  // }
  StreamController<List> streamStatusDash = StreamController.broadcast();
  List<DashStatusModel> status = [];
  GetStatusDash statusState = GetStatusDash();
  Future<void> getStatus() async {
    status = await GetStatusDash.readStat();
    streamStatusDash.add(status);
  }
  // bool? statusPlant;
  // Future<void> plantState() async {
  //   PlantStatus().statusPlant().then((value) {
  //     setState(() {
  //       statusPlant = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    // plantState();
    OEEData();
    // avaiState();
    qualityData();
    getValidUser();
    getStatus();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getStatus();
      qualityData();
      // plantState();
      OEEData();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  bool slide = false;
  String? name, otoritas;
  Future<void> getValidUser() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getName = shared.getString("name");
    var getOtoritas = shared.getString("otoritas");
    setState(() {
      name = getName!;
      otoritas = getOtoritas!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    // Mengetahui Orientasi Device
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: Scaffold(
          extendBodyBehindAppBar: true,
          //APPBAR----------------------------------------------------------------------------------------------------------------
          appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            toolbarHeight: blockVertical * 6,
            centerTitle: true,
            title: Text(
              "Production Monitoring System",
              style: TextStyle(
                  color: Color.fromARGB(255, 235, 235, 235),
                  fontSize: blockVertical * 2,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black.withOpacity(0.2),
            shadowColor: Colors.transparent,
            // leading: Builder(
            //   builder: (context) => IconButton(
            //     onPressed: () {
            //       Scaffold.of(context).openDrawer();
            //     },
            //     icon: Icon(
            //       FontAwesomeIcons.bars,
            //       size: blockVertical * 2.5,
            //       color: Color.fromARGB(255, 235, 235, 235),
            //     ),
            //   ),
            // ),
          ),
          //DRAWER-------------------------------------------------------------------------------------------------------------------------
          // drawer: TheDrawer(
          //   mode: "Dashboard",
          // ),
          //LANDSCAPE-------------------------------------------------------------------------------------------------------------------
          //BODY---------------------------------------------------------------------------------------------------------------------------
          body:
              //POTRAIT------------------------------------------------------------------------------------------------------------------
              Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 217, 240, 255),
              image: DecorationImage(
                  image: AssetImage('images/asset20.jpg'), fit: BoxFit.cover),
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: blockVertical * 10,
              ),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Color.fromARGB(255, 214, 211, 211).withOpacity(0.7),
                    Color.fromARGB(255, 37, 37, 37).withOpacity(0.9)
                  ])),
              child: RefreshIndicator(
                displacement: blockVertical * 3,
                onRefresh: () async {
                  await qualityData();
                  await getStatus();
                  // await avaiState();
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //LOGIN DATA---------------------------------------------------------------------------------------------------------
                      Padding(
                        padding: EdgeInsets.only(
                            left: blockHorizontal * 2.5,
                            bottom: blockVertical * 2,
                            top: blockVertical * 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      (name == "Berlliyanto Aji Nugraha")
                                          ? AssetImage('images/asset21.jpg')
                                          : AssetImage('images/asset11.png'),
                                ),
                                SizedBox(
                                  width: blockHorizontal * 2,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello, $name",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          fontWeight: FontWeight.bold,
                                          fontSize: blockVertical * 2),
                                    ),
                                    Text(
                                      "$otoritas",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          fontSize: blockVertical * 1.5),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            (otoritas == "Admin")
                                ? IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, myakun,
                                          arguments: "dari dashboard");
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.user,
                                      size: blockVertical * 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      //STATUS MESIN--------------------------------------------------------------------------------------------------------------
                      // Container(
                      //     margin: EdgeInsets.only(
                      //         left: blockHorizontal * 3,
                      //         right: blockHorizontal * 3,
                      //         bottom: blockVertical * 1),
                      //     height: blockVertical * 4,
                      //     width: MediaQuerywidth,
                      //     padding: EdgeInsets.all(blockVertical * 1),
                      //     alignment: Alignment.centerLeft,
                      //     decoration: BoxDecoration(
                      //         color: (statusPlant == true)
                      //             ? Colors.green
                      //             : Colors.red,
                      //         borderRadius:
                      //             BorderRadius.circular(blockVertical * 1)),
                      //     child: Text(
                      //       "Plant Status : ${(statusPlant == true) ? 'Connected' : 'Not-Connected'}",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: blockVertical * 2,
                      //           fontWeight: FontWeight.bold),
                      //     )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: blockHorizontal * 3),
                        child: Container(
                          height: blockVertical * 6,
                          width: MediaQuerywidth,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 25, 134),
                              borderRadius:
                                  BorderRadius.circular(blockVertical * 1),
                              image: DecorationImage(
                                  image: AssetImage('images/asset10.png'),
                                  fit: BoxFit.cover)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Expanded(
                                //   child:
                                StreamBuilder(
                                    stream: streamProd.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        qList.map((e) {
                                          return Padding(
                                              padding: EdgeInsets.all(
                                                  blockVertical * 1),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: blockHorizontal * 2,
                                                  ),
                                                  Text(
                                                    "Active Main Machine",
                                                    style: TextStyle(
                                                        fontSize: 28,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: blockHorizontal * 5,
                                                  ),
                                                  CircleAvatar(
                                                      radius:
                                                          blockVertical * 2.5,
                                                      backgroundColor: (e
                                                                  .state ==
                                                              1)
                                                          //     &&
                                                          // statusPlant ==
                                                          //     true)
                                                          ? Colors.green
                                                          : Colors.green
                                                              .withOpacity(0.1),
                                                      child: Icon(
                                                        FontAwesomeIcons.check,
                                                        color: (e.state == 1)
                                                            //     &&
                                                            // statusPlant ==
                                                            //     true)
                                                            ? Colors.white
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.1),
                                                        size:
                                                            blockVertical * 2.5,
                                                      )),
                                                  SizedBox(
                                                    width: blockHorizontal * 2,
                                                  ),
                                                  Text(
                                                    "/",
                                                    style: TextStyle(
                                                        fontSize: 28,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: blockHorizontal * 2,
                                                  ),
                                                  CircleAvatar(
                                                      radius:
                                                          blockVertical * 2.5,
                                                      backgroundColor: (e
                                                                  .state ==
                                                              1)
                                                          //     &&
                                                          // statusPlant ==
                                                          //     true)
                                                          ? Colors.red
                                                              .withOpacity(0.1)
                                                          : Colors.red,
                                                      child: Icon(
                                                        FontAwesomeIcons.x,
                                                        color: (e.state == 1)
                                                            //     &&
                                                            // statusPlant ==
                                                            //     true)
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.1)
                                                            : Colors.white,
                                                        size:
                                                            blockVertical * 2.5,
                                                      )),
                                                ],
                                              ));
                                        }).toList();
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Shimmer.fromColors(
                                            baseColor: Color.fromARGB(
                                                255, 201, 201, 201),
                                            highlightColor: Colors.white,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.05),
                                              constraints: BoxConstraints(
                                                  maxHeight: double.infinity,
                                                  maxWidth: double.infinity),
                                              height: blockVertical * 6,
                                              width: MediaQuerywidth,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          blockVertical * 1),
                                                  color: Colors.white),
                                            ));
                                      }
                                      {
                                        return Center(
                                            child: Text(
                                                "Error: ${snapshot.error}"));
                                      }
                                      // return Center(
                                      //     child: CircularProgressIndicator());
                                      // return Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.start,
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.center,
                                      //   children: [
                                      //     SizedBox(
                                      //       width: blockHorizontal * 2,
                                      //     ),
                                      //     Text(
                                      //       "Active Main Machine",
                                      //       style: TextStyle(
                                      //           fontSize: 28,
                                      //           color: Colors.white,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //     SizedBox(
                                      //       width: blockHorizontal * 4,
                                      //     ),
                                      //     CircleAvatar(
                                      //         radius: blockVertical * 2.5,
                                      //         backgroundColor:
                                      //             Colors.green.withOpacity(0.1),
                                      //         child: Icon(
                                      //           FontAwesomeIcons.check,
                                      //           color: Colors.white
                                      //               .withOpacity(0.1),
                                      //           size: blockVertical * 2.5,
                                      //         )),
                                      //     SizedBox(
                                      //       width: blockHorizontal * 2,
                                      //     ),
                                      //     Text(
                                      //       "/",
                                      //       style: TextStyle(
                                      //           fontSize: 28,
                                      //           color: Colors.white),
                                      //     ),
                                      //     SizedBox(
                                      //       width: blockHorizontal * 2,
                                      //     ),
                                      //     CircleAvatar(
                                      //         radius: blockVertical * 2.5,
                                      //         backgroundColor: Colors.red,
                                      //         child: Icon(
                                      //           FontAwesomeIcons.x,
                                      //           color: Colors.white,
                                      //           size: blockVertical * 2.5,
                                      //         )),
                                      //   ],
                                      // );
                                    }),
                                // )
                              ]),
                        ),
                      ),
                      //BODY MENU-------------------------------------------------------------------------------------------------------------
                      Container(
                        padding: EdgeInsets.only(top: blockVertical * 1),
                        margin: EdgeInsets.only(top: blockVertical * 2),
                        height: blockVertical * 90,
                        width: MediaQuerywidth,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: blockVertical * 0.5,
                                width: blockHorizontal * 10,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            SizedBox(
                              height: blockVertical * 2,
                            ),
                            //MENU MESIN--------------------------------------------------------------------------------------------------

                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 20),
                              child: Text(
                                "Production",
                                style: TextStyle(
                                    fontSize: blockVertical * 3,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //SLIDER PRODCUTION-------------------------------------------------------------------------------------------
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              height: blockVertical * 30,
                              width: MediaQuerywidth,
                              color: Colors.transparent,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return StreamBuilder<Object>(
                                      stream: streamProd.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          qList.map((e) {
                                            //Mesin----------------------------------------------------------
                                            return menuProduction(
                                              constraints,
                                              Color.fromARGB(255, 87, 89, 236),
                                              Color.fromARGB(255, 18, 2, 240),
                                              "Main Machine",
                                              mym1monitoring,
                                              (e.machine_id == 1 &&
                                                      e.state == 1)
                                                  ? " Running"
                                                  : " Stop/Finish",
                                              // (e.state == 1)
                                              //     ? "Type 0"
                                              //     : "Type -",
                                              (e.state == 1)
                                                  ? "Processed Unit : ${e.processed}"
                                                  : "Processed Unit : -",
                                              (e.state == 1)
                                                  ? "Good Processed : ${e.good}"
                                                  : "Good Processed : -",
                                              (e.state == 1)
                                                  ? "Defect : ${e.defect}"
                                                  : "Defect : -",
                                              (e.machine_id == 1 &&
                                                      e.state == 1)
                                                  ? Color.fromARGB(
                                                      255, 24, 240, 4)
                                                  : Color.fromARGB(
                                                      255, 240, 4, 4),
                                            );
                                          }).toList();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ShimmerProd(constraints);
                                          // ShimmerProd(constraints),
                                          // ShimmerProd(constraints),
                                          // ShimmerProd(constraints),
                                        }
                                        return menuProduction(
                                            constraints,
                                            Color.fromARGB(255, 87, 89, 236),
                                            Color.fromARGB(255, 2, 18, 240),
                                            "Main Machine",
                                            mym1monitoring,
                                            " -",
                                            // "Type -",
                                            "Processed Unit : -",
                                            "Good Processed : -",
                                            "Defect : -",
                                            Color.fromARGB(255, 240, 4, 4));
                                      });
                                },
                              ),
                            ),
                            Divider(
                              thickness: blockVertical * 1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 20),
                              child: Text(
                                "Overall Equipment Effectiveness",
                                style: TextStyle(
                                    fontSize: blockVertical * 3,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //OEE---------------------------------------------------------------------------------------------------------------
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: blockVertical * 30,
                              width: MediaQuerywidth,
                              color: Colors.transparent,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return StreamBuilder<Object>(
                                      stream: streamProd.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          oeeList.map((e) {
                                            //Mesin----------------------------------------------------------
                                            return menuOEE(
                                                blockVertical,
                                                Color.fromARGB(255, 0, 98, 226),
                                                "Main Machine",
                                                (e.nilaioee <= 1.0)
                                                    ? e.nilaioee.toDouble()
                                                    : 1.0,
                                                "${(e.nilaioee * 100).toStringAsFixed(2)}%");
                                          }).toList();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return shimmerOEE(blockVertical);
                                        }
                                        return menuOEE(
                                            blockVertical,
                                            Colors.black,
                                            "Main Machine",
                                            0.0,
                                            "0.0");
                                      });
                                },
                              ),
                            ),

                            SizedBox(
                              height: blockVertical * 3,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: (otoritas == "Admin")
              ? SpeedDial(
                  icon: Icons.menu_rounded,
                  activeIcon: Icons.close_rounded,
                  spacing: 3,
                  mini: false,
                  openCloseDial: ValueNotifier<bool>(false),
                  childPadding: const EdgeInsets.all(5),
                  spaceBetweenChildren: 4,
                  buttonSize: const Size(56.0, 56.0),
                  childrenButtonSize: const Size(56.0, 56.0),
                  visible: true,
                  direction: SpeedDialDirection.up,
                  switchLabelPosition: false,
                  closeManually: false,
                  renderOverlay: true,
                  onOpen: () => debugPrint('OPENING DIAL'),
                  onClose: () => debugPrint('DIAL CLOSED'),
                  useRotationAnimation: true,
                  tooltip: 'Menu',
                  elevation: 8.0,
                  animationCurve: Curves.elasticInOut,
                  isOpenOnStart: false,
                  shape: const StadiumBorder(),
                  children: [
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.gauge),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, mym1home,
                            arguments: 'from drawer');
                      },
                      label: 'Main Machine',
                      onLongPress: () => debugPrint('Main Machine'),
                    ),
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.chartArea),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, mypreventive,
                            arguments: 'from drawer');
                      },
                      label: 'Preventive Maintenance',
                      onLongPress: () => debugPrint('Preventive Maintenance'),
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.picture_as_pdf_rounded),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, myreport,
                            arguments: 'from drawer');
                      },
                      label: 'Report',
                      onLongPress: () => debugPrint('Report'),
                    ),
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.userGroup),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, myakun,
                            arguments: 'from drawer');
                      },
                      label: 'Manage Accounts',
                      onLongPress: () => debugPrint('Manage Accounts'),
                    ),
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.arrowRightFromBracket),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.leftSlide,
                            title: "Log Out",
                            desc: "Are You Sure You Want To Exit?",
                            useRootNavigator: true,
                            btnCancelIcon: FontAwesomeIcons.xmark,
                            btnCancelOnPress: () {},
                            btnOkIcon: FontAwesomeIcons.arrowRightFromBracket,
                            btnOkOnPress: () async {
                              final SharedPreferences shared =
                                  await SharedPreferences.getInstance();
                              shared.remove("name");
                              shared.remove("otoritas");
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, mylogin,
                                  arguments: "from drawer");
                            }).show();
                      },
                      label: 'Log Out',
                      onLongPress: () => debugPrint('Log Out'),
                    ),
                  ],
                )
              : SpeedDial(
                  icon: Icons.menu_rounded,
                  activeIcon: Icons.close_rounded,
                  spacing: 3,
                  mini: false,
                  openCloseDial: ValueNotifier<bool>(false),
                  childPadding: const EdgeInsets.all(5),
                  spaceBetweenChildren: 4,
                  buttonSize: const Size(56.0, 56.0),
                  childrenButtonSize: const Size(56.0, 56.0),
                  visible: true,
                  direction: SpeedDialDirection.up,
                  switchLabelPosition: false,
                  closeManually: false,
                  renderOverlay: true,
                  onOpen: () => debugPrint('OPENING DIAL'),
                  onClose: () => debugPrint('DIAL CLOSED'),
                  useRotationAnimation: true,
                  tooltip: 'Menu',
                  elevation: 8.0,
                  animationCurve: Curves.elasticInOut,
                  isOpenOnStart: false,
                  shape: const StadiumBorder(),
                  children: [
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.gauge),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, mym1home,
                            arguments: 'from drawer');
                      },
                      label: 'Main Machine',
                      onLongPress: () => debugPrint('Main Machine'),
                    ),
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.chartArea),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, mypreventive,
                            arguments: 'from drawer');
                      },
                      label: 'Preventive Maintenance',
                      onLongPress: () => debugPrint('Preventive Maintenance'),
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.picture_as_pdf_rounded),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, myreport,
                            arguments: 'from drawer');
                      },
                      label: 'Report',
                      onLongPress: () => debugPrint('Report'),
                    ),
                    SpeedDialChild(
                      child: Icon(FontAwesomeIcons.arrowRightFromBracket),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.leftSlide,
                            title: "Log Out",
                            desc: "Are You Sure You Want To Exit?",
                            useRootNavigator: true,
                            btnCancelIcon: FontAwesomeIcons.xmark,
                            btnCancelOnPress: () {},
                            btnOkIcon: FontAwesomeIcons.arrowRightFromBracket,
                            btnOkOnPress: () async {
                              final SharedPreferences shared =
                                  await SharedPreferences.getInstance();
                              shared.remove("name");
                              shared.remove("otoritas");
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, mylogin,
                                  arguments: "from drawer");
                            }).show();
                      },
                      label: 'Log Out',
                      onLongPress: () => debugPrint('Log Out'),
                    ),
                  ],
                )),
    );
  }

//MENU MESIN------------------------------------------------------------------
  Widget menuMesin(
      String title, IconData icon, Color colors, String navigator) {
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return Container(
      color: Colors.transparent,
      height: blockVertical * 15,
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: colors,
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, navigator,
                        arguments: "from dashboard");
                  },
                  icon: Icon(icon)),
            ),
            SizedBox(
              height: blockVertical * 0.5,
            ),
            Text(
              title,
              style: TextStyle(fontSize: blockVertical * 1.5),
            )
          ],
        );
      }),
    );
  }

//EFEK SHIMMER ------------------------------------------------------------------
  ClipRRect shimmerKonek(
      BoxConstraints constraints, double blockVertical, double) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(blockVertical * 1),
      child: Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 201, 201, 201),
        highlightColor: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxHeight * 0.05,
              vertical: constraints.maxHeight * 0.05),
          height: constraints.maxHeight * 0.7,
          width: constraints.maxWidth * 0.7,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 201, 201, 201),
          ),
        ),
      ),
    );
  }

  Widget shimmerOEE(double blockVertical) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 201, 201, 201),
      highlightColor: Colors.white,
      child: CircleAvatar(
        radius: blockVertical * 10,
        backgroundColor: Color.fromARGB(255, 201, 201, 201),
      ),
    );
  }

  Widget ShimmerProd(
    BoxConstraints constraints,
  ) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer.fromColors(
          baseColor: Color.fromARGB(255, 201, 201, 201),
          highlightColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxHeight * 0.05,
                vertical: constraints.maxHeight * 0.05),
            height: constraints.maxHeight * 0.7,
            width: constraints.maxWidth * 0.7,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 201, 201, 201),
            ),
          ),
        ));
  }

//MENU PRODUCTION CAROUSEL-----------------------------------------------------
  Widget menuProduction(
      BoxConstraints constraints,
      Color color1,
      Color color2,
      String title,
      String routes,
      String status,
      // String tipe,
      String Processed,
      String Good,
      String Defect,
      Color colorStatus) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxHeight * 0.05,
            vertical: constraints.maxHeight * 0.05),
        height: constraints.maxHeight * 0.7,
        width: constraints.maxWidth * 0.7,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [color1, color2],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxHeight * 0.12,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: constraints.maxHeight * 0.2,
                  width: constraints.maxWidth * 0.15,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 110, 110, 110).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, routes,
                              arguments: "from dashboard");
                        },
                        icon: Icon(
                          FontAwesomeIcons.arrowRightLong,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.1,
                      width: constraints.maxHeight * 0.1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: colorStatus),
                    ),
                    Text(status,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: constraints.maxHeight * 0.08)),
                  ],
                ),
                // Text(tipe,
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontSize: constraints.maxHeight * 0.08))
              ],
            ),
            Divider(
              thickness: constraints.maxHeight * 0.01,
            ),
            Text(Processed,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: constraints.maxHeight * 0.08)),
            Text(Good,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: constraints.maxHeight * 0.08)),
            Text(Defect,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: constraints.maxHeight * 0.08))
          ],
        ),
      ),
    );
  }

  Widget menuOEE(double blockVertical, Color color, String title,
      double percent, String Value) {
    return CircularPercentIndicator(
      animateFromLastPercent: true,
      progressColor: color,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 2,
      percent: percent,
      radius: blockVertical * 8,
      lineWidth: blockVertical * 2,
      header: Text(
        title,
        style: TextStyle(
          fontSize: blockVertical * 2.5,
        ),
      ),
      center: Text(
        Value,
        style: TextStyle(fontSize: blockVertical * 2),
      ),
    );
  }
}
