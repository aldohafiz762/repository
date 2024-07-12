// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:project_tugas_akhir_copy/additional/report_pdf.dart';
import 'package:project_tugas_akhir_copy/services/availability_service.dart';
import 'package:project_tugas_akhir_copy/services/oee_service.dart';
// import 'package:project_tugas_akhir_copy/services/param_service.dart';
import 'package:project_tugas_akhir_copy/services/performance_service.dart';
import 'package:project_tugas_akhir_copy/services/quality_service.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/models/availability_model.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';
// import 'package:project_tugas_akhir_copy/models/param_model.dart';
import 'package:project_tugas_akhir_copy/models/performance_model.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class M1oee extends StatefulWidget {
  static const nameRoute = '/m1oee';
  const M1oee(String m, {super.key});

  @override
  State<M1oee> createState() => _M1oeeState();
}

class _M1oeeState extends State<M1oee> {
  late Timer timer;
  String? tipe;
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

  TextEditingController jumlah = TextEditingController();

  // // PARAMETER
  // StreamController<List> streamParam = StreamController.broadcast();
  // List<ParamModel> paramList = [];
  // ReadLatestParamM1 getLatestParamM1 = ReadLatestParamM1();
  // Future<void> latestParam() async {
  //   paramList = await getLatestParamM1.getParamM1();
  //   streamParam.add(paramList);
  // }

  //QUALITY
  StreamController<List<DashQuality>> streamProd = StreamController.broadcast();
  List<DashQuality> qList = [];
  QualityDash quality = QualityDash();
  Future<void> qualityData() async {
    qList = await QualityDash.dashQualityM();
    streamProd.add(qList);
  }

  //AVAILABILITY
  StreamController<List<AvaiModelM>> streamTime = StreamController.broadcast();
  List<AvaiModelM> aList = [];
  GetAvailability availability = GetAvailability();
  Future<void> avaidata() async {
    try {
      aList = await GetAvailability.availabilityM();
      if (aList.isEmpty) {
        print("AvaiModelM data is empty");
      } else {
        print("AvaiModelM data fetched successfully: ${aList.length} items");
      }
      streamTime.add(aList);
    } catch (e) {
      print("Error fetching AvaiModelM data: $e");
      streamTime.addError(e);
    }
  }

//PERFORMANCE
  StreamController<List<GetPerformanceModel>> streamPerform =
      StreamController.broadcast();
  List<GetPerformanceModel> pList = [];
  GetPerformance performance = GetPerformance();
  Future<void> performData() async {
    pList = await GetPerformance.getPerform();
    streamPerform.add(pList);
  }

  //OEE
  StreamController<List> streamOEE = StreamController.broadcast();
  List<GetOEEModel> OEEList = [];
  GetOEE OEE = GetOEE();
  Future<void> OEEdata() async {
    OEEList = await OEE.getResult(1);
    streamOEE.add(OEEList);
  }

  // final List<GetOEEModel> oeeSlider = StreamBuilder<Object>(stream: streamOEE.stream, builder: builder)
  @override
  void initState() {
    getValidUser();
    OEEdata();
    performData();
    avaidata();
    qualityData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      performData();
      avaidata();
      qualityData();
      OEEdata();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Monitoring OEE",
              style: TextStyle(
                  fontSize: blockVertical * 3,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 6, 160, 207),
            toolbarHeight: blockVertical * 8,
            leading: backbutton(context),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 29, 206, 215),
                    Color.fromARGB(255, 19, 78, 227),
                  ]),
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: blockVertical * 1),
                    StreamBuilder(
                      stream: streamOEE.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              SizedBox(height: blockVertical * 0.5),
                              Text(
                                "Overall Equipment and Effectivenes",
                                style: TextStyle(
                                    fontSize: blockVertical * 2.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: blockHorizontal * 3),
                                      height: blockVertical * 5,
                                      width: blockHorizontal * 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                              blockVertical * 1)),
                                    ),
                                  )
                                ],
                              ),
                              Shimmer.fromColors(
                                highlightColor: Colors.white,
                                baseColor: Colors.grey,
                                child: CircleAvatar(
                                  radius: blockVertical * 10,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: blockVertical * 2.5,
                              ),
                              ShimmerrowOEE(blockHorizontal, blockVertical)
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error Bro: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          List<dynamic> statusList = snapshot.data!;
                          return Column(
                            children: OEEList.map((e) {
                              print('data: ${e}');
                              dynamic oee = e.nilaioee! * 100;
                              dynamic quality = e.quality! * 100;
                              dynamic availability = e.availability! * 100;
                              dynamic performance = e.performance! * 100;
                              return CarouselSlider(
                                options: CarouselOptions(
                                  height: blockVertical * 40,
                                  enlargeCenterPage: true,
                                  autoPlay: false,
                                ),
                                items: [
                                  percentOEE(
                                      blockHorizontal,
                                      blockVertical,
                                      "Overall Equipment Effectiveness",
                                      oee,
                                      85,
                                      Colors.lightBlue,
                                      Colors.lightBlue,
                                      (e.nilaioee <= 1.0)
                                          ? e.nilaioee.toDouble()
                                          : 1.0,
                                      oee.toStringAsFixed(2)),
                                  percentOEE(
                                      blockHorizontal,
                                      blockVertical,
                                      "Availability",
                                      availability,
                                      90,
                                      Colors.lightBlue,
                                      Colors.lightBlue,
                                      (e.availability <= 1.0)
                                          ? e.availability.toDouble()
                                          : 1.0,
                                      availability.toStringAsFixed(2)),
                                  percentOEE(
                                      blockHorizontal,
                                      blockVertical,
                                      "Performance",
                                      performance,
                                      95,
                                      Colors.lightBlue,
                                      Colors.lightBlue,
                                      (e.performance <= 1.0)
                                          ? e.performance.toDouble()
                                          : 1.0,
                                      performance.toStringAsFixed(2)),
                                  percentOEE(
                                      blockHorizontal,
                                      blockVertical,
                                      "Quality",
                                      quality,
                                      99,
                                      Colors.lightBlue,
                                      Colors.lightBlue,
                                      (e.quality <= 1.0)
                                          ? e.quality.toDouble()
                                          : 1.0,
                                      quality.toStringAsFixed(2)),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return Center(child: Text("No data available"));
                        }
                      },
                    ),
                    Container(
                      height: blockVertical * 85,
                      width: MediaQuerywidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: blockVertical * 1.5,
                          ),
                          //Production
                          Center(
                            child: Text(
                              "Production Monitoring System",
                              style: TextStyle(
                                  fontSize: blockVertical * 3,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: blockVertical * 1,
                          ),
                          Divider(thickness: blockVertical * 1),
                          Container(
                            padding: EdgeInsets.only(
                                left: blockHorizontal * 10,
                                right: blockHorizontal * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: blockVertical * 20,
                                  width: blockHorizontal * 40,
                                  padding: EdgeInsets.only(
                                      right: blockHorizontal * 8),
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Availability",
                                            style: TextStyle(
                                                fontSize: blockVertical * 3,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Time",
                                            style: TextStyle(
                                                fontSize: blockVertical * 3,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // IconButton(
                                          //     onPressed: () {},
                                          //     icon: Icon(
                                          //       Icons.info_outline_rounded,
                                          //       size: blockVertical * 5,
                                          //       color: Color.fromARGB(
                                          //           255, 143, 141, 141),
                                          //     ))
                                        ]),
                                  ),
                                ),
                                StreamBuilder<List<AvaiModelM>>(
                                  stream: streamTime.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ShimmerBody(
                                          blockHorizontal, blockVertical);
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              "Error Bro: ${snapshot.error}"));
                                    } else if (snapshot.hasData) {
                                      List<AvaiModelM> aList = snapshot.data!;
                                      return Column(
                                        children: aList.map((e) {
                                          print('data: ${e}');
                                          return NilaiProduction(
                                              blockHorizontal,
                                              blockVertical,
                                              "Downtime",
                                              // (e.state == 1)
                                              // ?
                                              "${((e.setup / 60) + (e.breakdown / 60)).toStringAsFixed(2)} Minutes",
                                              // : "- Unit",
                                              "Uptime",
                                              // (e.state == 1)
                                              //     ?
                                              "${(e.operation / 60).toStringAsFixed(2)} Minutes",
                                              // : "- Unit",
                                              "Overall time",
                                              // (e.state == 1)
                                              "10 Minutes");
                                          // : "- Unit");
                                        }).toList(),
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No data available"));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: blockVertical * 1,
                          ),

                          Container(
                            padding: EdgeInsets.only(
                                right: blockHorizontal * 10,
                                left: blockHorizontal * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: blockVertical * 20,
                                  width: blockHorizontal * 40,
                                  padding: EdgeInsets.only(
                                      right: blockHorizontal * 8),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Performance",
                                          style: TextStyle(
                                              fontSize: blockVertical * 3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Time",
                                          style: TextStyle(
                                              fontSize: blockVertical * 3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // IconButton(
                                        //     onPressed: () {},
                                        //     icon: Icon(
                                        //       Icons.info_outline_rounded,
                                        //       size: blockVertical * 5,
                                        //       color: Color.fromARGB(
                                        //           255, 143, 141, 141),
                                        //     ))
                                      ],
                                    ),
                                  ),
                                ),
                                StreamBuilder<List<GetPerformanceModel>>(
                                  stream: streamPerform.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ShimmerBody(
                                          blockHorizontal, blockVertical);
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              "Error Bro: ${snapshot.error}"));
                                    } else if (snapshot.hasData) {
                                      List<GetPerformanceModel> performance =
                                          snapshot.data!;
                                      return Column(
                                        children: performance.map((e) {
                                          print('data: ${e}');
                                          return NilaiProduction(
                                              blockHorizontal,
                                              blockVertical,
                                              "Cycle Ideal / Unit",
                                              // (e.state == 1)
                                              // ?
                                              "3.8 Seconds",
                                              // : "- Unit",
                                              "Speedloss / Unit",
                                              // (e.state == 1)
                                              //     ?
                                              "${(e.speedAvg! / 60).toStringAsFixed(2)} Minutes",
                                              // : "- Unit",
                                              "Delay Stop / Unit",
                                              // (e.state == 1)
                                              "${(e.stoppageAvg! / 60).toStringAsFixed(2)} Minutes");
                                          // : "- Unit");
                                        }).toList(),
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No data available"));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: blockVertical * 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: blockHorizontal * 10,
                                right: blockHorizontal * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: blockVertical * 20,
                                  width: blockHorizontal * 40,
                                  padding: EdgeInsets.only(
                                      right: blockHorizontal * 8),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Quality",
                                          style: TextStyle(
                                              fontSize: blockVertical * 3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Control",
                                          style: TextStyle(
                                              fontSize: blockVertical * 3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                StreamBuilder<List<DashQuality>>(
                                  stream: streamProd.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ShimmerBody(
                                          blockHorizontal, blockVertical);
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              "Error Bro: ${snapshot.error}"));
                                    } else if (snapshot.hasData) {
                                      List<DashQuality> pList = snapshot.data!;
                                      return Column(
                                        children: pList.map((e) {
                                          print('data: ${e}');
                                          return NilaiProduction(
                                              blockHorizontal,
                                              blockVertical,
                                              "Processed",
                                              // (e.state == 1)
                                              // ?
                                              "${e.processed.toInt()} Units",
                                              // : "- Unit",
                                              "Good Product",
                                              // (e.state == 1)
                                              //     ?
                                              "${e.good.toInt()} Units",
                                              // : "- Unit",
                                              "Reject Product",
                                              // (e.state == 1)
                                              "${e.defect.toInt()} Units");
                                          // : "- Unit");
                                        }).toList(),
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No data available"));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: blockVertical * 1,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: blockHorizontal * 5,
                                vertical: blockVertical * 2),
                            child: (otoritas == "Admin" ||
                                    otoritas == "User-QC")
                                ? buttonDefect(blockHorizontal, blockVertical)
                                : buttonDefectDis(
                                    blockHorizontal, blockVertical),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }

  // Widget ShimmerBody(
  //   double blockHorizontal,
  //   double blockVertical,
  // ) {
  //   return Shimmer.fromColors(
  //     baseColor: Colors.grey,
  //     highlightColor: Colors.white,
  //     child: Container(
  //       height: blockVertical * 20,
  //       width: blockHorizontal * 40,
  //       decoration: BoxDecoration(
  //           color: Colors.grey,
  //           border: Border.all(color: Colors.black12),
  //           borderRadius: BorderRadius.circular(blockVertical * 1)),
  //     ),
  //   );
  // }

  Widget NilaiProduction(
    double blockHorizontal,
    double blockVertical,
    String baris1,
    String subBaris1,
    String baris2,
    String subBaris2,
    String baris3,
    String subBaris3,
  ) {
    return Container(
      height: blockVertical * 20,
      width: blockHorizontal * 40,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.bottomRight,
              begin: Alignment.topLeft,
              colors: [
                Color.fromARGB(255, 180, 179, 179).withOpacity(0.5),
                Color.fromARGB(255, 182, 182, 182).withOpacity(0.2),
              ]),
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(blockVertical * 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            baris1,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: blockVertical * 1.8),
          ),
          Text(
            subBaris1,
            style: TextStyle(fontSize: blockVertical * 1.8),
          ),
          Divider(
            color: Colors.transparent,
            thickness: blockVertical * 0.5,
          ),
          Text(
            baris2,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: blockVertical * 1.8),
          ),
          Text(
            subBaris2,
            style: TextStyle(fontSize: blockVertical * 1.8),
          ),
          Divider(color: Colors.transparent, thickness: blockVertical * 0.5),
          Text(
            baris3,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: blockVertical * 1.8),
          ),
          Text(
            subBaris3,
            style: TextStyle(fontSize: blockVertical * 1.8),
          ),
        ],
      ),
    );
  }

  Widget buttonDefect(double blockHorizontal, double blockVertical) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: blockHorizontal * 100,
        height: blockVertical * 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(211, 122, 2, 18),
                  Color.fromARGB(235, 99, 14, 14)
                ])),
        child: Material(
          type: MaterialType.canvas,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            highlightColor: Color.fromARGB(255, 255, 0, 0),
            radius: blockVertical * 10,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      useRootNavigator: true,
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Input Defect Unit",
                            style: TextStyle(
                                fontSize: blockVertical * 2.5,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: blockVertical * 1.5,
                          ),
                          TextField(
                            controller: jumlah,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Input Defect (unit)"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "*If there is no defect, please enter a value 0 or skip",
                                style: TextStyle(fontSize: blockVertical * 1.3),
                              ),
                            ],
                          )
                        ],
                      ),
                      btnOkText: "Add",
                      btnOkIcon: FontAwesomeIcons.plus,
                      btnOkOnPress: () {
                        InputDefect.defectQuality(int.parse(jumlah.text));
                      },
                      btnCancelIcon: FontAwesomeIcons.ban,
                      btnCancelOnPress: () {})
                  .show();
            },
            child: Center(
              child: Text(
                "Input Defect Unit",
                style: TextStyle(
                    fontSize: blockVertical * 2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonDefectDis(double blockHorizontal, double blockVertical) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: blockHorizontal * 100,
        height: blockVertical * 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(210, 158, 158, 158),
                  Color.fromARGB(235, 124, 124, 124)
                ])),
        child: Center(
          child: Text(
            "Input Defect Unit",
            style: TextStyle(
                fontSize: blockVertical * 2,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget NilaiOEE(
    double blockHorizontal,
    double blockVertical,
    String baris1,
    String subBaris1,
    String baris2,
    String subBaris2,
    String baris3,
    String subBaris3,
  ) {
    return Container(
      height: blockVertical * 20,
      width: blockHorizontal * 40,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.bottomRight,
              begin: Alignment.topLeft,
              colors: [
                Color.fromARGB(255, 180, 179, 179).withOpacity(0.5),
                Color.fromARGB(255, 182, 182, 182).withOpacity(0.2),
              ]),
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(blockVertical * 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            baris1,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: blockVertical * 1.8),
          ),
          Text(
            subBaris1,
            style: TextStyle(fontSize: blockVertical * 1.8),
          ),
          Divider(
            color: Colors.transparent,
            thickness: blockVertical * 0.5,
          ),
          Text(
            baris2,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: blockVertical * 1.8),
          ),
          Text(
            subBaris2,
            style: TextStyle(fontSize: blockVertical * 1.8),
          ),
          Divider(color: Colors.transparent, thickness: blockVertical * 0.5),
          Text(
            baris3,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: blockVertical * 1.8),
          ),
          Text(
            subBaris3,
            style: TextStyle(fontSize: blockVertical * 1.8),
          ),
        ],
      ),
    );
  }

  Widget percentOEE(
      double blockHorizontal,
      double blockVertical,
      String title,
      dynamic target,
      int ideal,
      Color colors1,
      Color colors2,
      double value,
      String center) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: blockHorizontal * 2, vertical: blockVertical * 1),
      child: Container(
        height: blockHorizontal * 20,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(3, 5),
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(blockVertical * 2)),
        child: Column(
          children: [
            SizedBox(height: blockVertical * 0.5),
            Text(
              title,
              style: TextStyle(
                  fontSize: blockVertical * 2.5, fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: blockHorizontal * 3),
                  height: blockVertical * 5,
                  width: blockHorizontal * 30,
                  decoration: BoxDecoration(
                    color: (target.toDouble() <= ideal)
                        ? Color.fromARGB(255, 255, 17, 0).withOpacity(0.8)
                        : Color.fromARGB(255, 0, 138, 5).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(blockVertical * 1),
                  ),
                  child: Center(
                      child: Text(
                    "Target: ${ideal} %",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: blockVertical * 2,
                        fontWeight: FontWeight.bold),
                  )),
                )
              ],
            ),
            SizedBox(height: blockVertical * 2),
            CircularPercentIndicator(
              animateFromLastPercent: true,
              radius: blockVertical * 9,
              lineWidth: 15,
              percent: value,
              backgroundColor: colors2.withOpacity(0.5),
              progressColor: colors1,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 2000,
              center: Text(
                "$center %",
                style: TextStyle(fontSize: blockVertical * 2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ShimmerBody(
    double blockHorizontal,
    double blockVertical,
  ) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        height: blockVertical * 20,
        width: blockHorizontal * 40,
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(blockVertical * 1)),
      ),
    );
  }

  // Widget CircleBody(
  //   double blockHorizontal,
  //   double blockVertical,
  // ) {
  //   return Shimmer.fromColors(
  //     baseColor: Colors.grey,
  //     highlightColor: Colors.white,
  //     child: CircleAvatar(
  //       backgroundColor: Colors.grey,
  //       radius: blockVertical * 8,
  //     ),
  //   );
  // }

  Widget rowOEE(double blockHorizontal, double blockVertical,
      String availability, String performance, String quality) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "Availability",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: blockVertical * 2),
            ),
            Text("$availability %",
                style: TextStyle(fontSize: blockVertical * 2)),
          ],
        ),
        Column(
          children: [
            Text("Performance",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: blockVertical * 2)),
            Text("$performance %",
                style: TextStyle(fontSize: blockVertical * 2)),
          ],
        ),
        Column(
          children: [
            Text("Quality",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: blockVertical * 2)),
            Text("$quality %", style: TextStyle(fontSize: blockVertical * 2)),
          ],
        ),
      ],
    );
  }

  Widget circleOEE(double blockHorizontal, double blockVertical, double value,
      String center) {
    return Center(
      child: CircularPercentIndicator(
        radius: blockVertical * 10,
        lineWidth: 20,
        percent: value,
        backgroundColor: Colors.green.withOpacity(0.5),
        progressColor: Color.fromARGB(255, 0, 255, 8),
        circularStrokeCap: CircularStrokeCap.round,
        animateFromLastPercent: true,
        animation: true,
        animationDuration: 2000,
        center: Text(
          "$center %",
          style: TextStyle(fontSize: blockVertical * 3),
        ),
      ),
    );
  }

  Widget ShimmerrowOEE(double blockHorizontal, double blockVertical) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Container(
            height: blockVertical * 5,
            width: blockHorizontal * 80,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(blockHorizontal * 5)),
          ),
        )
      ],
    );
  }
}
