// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/availability_service.dart';
import 'package:project_tugas_akhir_copy/services/lifetime_service.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1energy_usage.dart';
import 'package:project_tugas_akhir_copy/mesin1/m1pressure.dart';
import 'package:project_tugas_akhir_copy/models/availability_model.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../services/param_service.dart';
import '../services/quality_service.dart';
import '../services/stock_service.dart';
import '../models/param_model.dart';
import '../models/stock_model.dart';

class M1monitoring extends StatefulWidget {
  static const nameRoute = '/m1monitoring ';
  const M1monitoring(
    String p, {
    super.key,
  });

  static const List<Tab> myTab = [
    Tab(
      text: "Production",
      icon: Icon(FontAwesomeIcons.computer),
    ),
    Tab(
      text: "Pressure",
      icon: Icon(FontAwesomeIcons.gauge),
    ),
    Tab(
      text: "Energy Usage",
      icon: Icon(FontAwesomeIcons.boltLightning),
    ),
  ];

  @override
  State<M1monitoring> createState() => _M1monitoringState();
}

class _M1monitoringState extends State<M1monitoring> {
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

  late Timer timer;
  int? state;
  int timevalue = 0;
  String? tipe;
  TextEditingController jumlah = TextEditingController();

  //STOCK
  StreamController<List> streamStock = StreamController.broadcast();
  List<StockModel> stockList = [];
  ReadStock getstockM1 = ReadStock();
  Future<void> stockData() async {
    stockList = await getstockM1.getStock(1);
    streamStock.add(stockList);
  }

  // PARAMETER
  StreamController<List> streamParam = StreamController.broadcast();
  List<ParamModel> paramList = [];
  ReadLatestParamM1 getLatestParamM1 = ReadLatestParamM1();
  Future<void> latestParam() async {
    paramList = await getLatestParamM1.getParamM1();
    streamParam.add(paramList);
  }

  //PRODUCTION
  StreamController<List> streamProd = StreamController.broadcast();
  List<CurrentQuality> qList = [];
  GetQuality quality = GetQuality();
  Future<void> qualityData() async {
    qList = await quality.getQualityM(1, "$tipe");
    streamProd.add(qList);
  }

  //PRODUCTION TIME
  StreamController<List> streamTime = StreamController.broadcast();
  List<AvaiModelM> aList = [];
  GetAvailability availability = GetAvailability();
  Future<void> avaidata() async {
    aList = await availability.availabilityM(1);
    streamTime.add(aList);
  }

  //Life Time
  Future<void> lifetime() async {
    GetOneLT().getOne(1).then((value) {
      timevalue = value;
    });
  }

  @override
  void initState() {
    getLatestParamM1.getTipe().then((value) {
      setState(() {
        tipe = value!;
      });
    });
    getValidUser();
    lifetime();
    avaidata();
    latestParam();
    qualityData();
    stockData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      lifetime();
      avaidata();
      latestParam();
      stockData();
      qualityData();
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
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: M1monitoring.myTab.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Machine 1 Monitoring",
              style: TextStyle(fontSize: blockVertical * 2.5),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 6, 160, 207),
            toolbarHeight: blockVertical * 8,
            leading: backbutton(context),
            bottom: TabBar(
              tabs: M1monitoring.myTab,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorPadding: EdgeInsets.all(5),
            ),
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
            child: TabBarView(
                children: [Production(context), M1pressure(), M1energy()]),
          ),
        ),
      ),
    );
  }

  //Production-----------------------------------------------------------------------------------------------------
  Widget Production(BuildContext context) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return SingleChildScrollView(
      child: StreamBuilder<Object>(
        stream: streamParam.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: paramList.map(
                (data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(blockHorizontal * 3,
                            blockVertical * 1, blockHorizontal * 3, 0),
                        height: blockVertical * 5,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 232, 253, 255),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(5, 5),
                                  blurRadius: 5)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "PARAMETER ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2,
                                  fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                                radius: blockVertical * 2,
                                backgroundColor: (data.state == 1)
                                    ? Colors.green
                                    : Colors.red,
                                child: Icon(
                                  (data.state == 1)
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.x,
                                  color: Colors.white,
                                  size: blockVertical * 2.5,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(blockVertical * 1),
                        margin: EdgeInsets.symmetric(
                            vertical: blockVertical * 1,
                            horizontal: blockHorizontal * 3),
                        height: blockVertical * 15,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: blockVertical * 0.5,
                                      horizontal: blockHorizontal * 3),
                                  height: blockVertical * 6,
                                  width: blockHorizontal * 42,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          blockVertical * 1)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Status Machine",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                fontSize: blockVertical * 1.2),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.piedPiper,
                                            size: blockVertical * 2,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                      StreamBuilder<Object>(
                                          stream: streamTime.stream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Row(
                                                children: aList.map((e) {
                                                  return statusMesin(
                                                      blockHorizontal,
                                                      blockVertical,
                                                      (e.state == 1)
                                                          ? Color.fromARGB(
                                                              255, 9, 255, 0)
                                                          : Color.fromARGB(
                                                              255, 255, 17, 0),
                                                      (e.state == 1)
                                                          ? " Running"
                                                          : " Stop/Finish");
                                                }).toList(),
                                              );
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return statusMesin(
                                                  blockHorizontal,
                                                  blockVertical,
                                                  Colors.grey,
                                                  " Waiting");
                                            }

                                            return statusMesin(
                                                blockHorizontal,
                                                blockVertical,
                                                Color.fromARGB(255, 255, 17, 0),
                                                " Stopped");
                                          })
                                    ],
                                  ),
                                ),
                                bodyCard(
                                    blockHorizontal,
                                    blockVertical,
                                    "Life Time",
                                    "${(timevalue / 60).toStringAsFixed(2)} Min",
                                    FontAwesomeIcons.heartPulse)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                bodyCard(
                                    blockHorizontal,
                                    blockVertical,
                                    "Object Type",
                                    (data.state == 1)
                                        ? "${data.tipe_benda}"
                                        : "-",
                                    FontAwesomeIcons.shapes),
                                StreamBuilder<Object>(
                                    stream: streamStock.stream,
                                    builder: (context, snapshot) {
                                      if (data.state == 1) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            children: stockList.map((e) {
                                              return bodyCard(
                                                  blockHorizontal,
                                                  blockVertical,
                                                  "Stock Amount",
                                                  (data.tipe_benda == "A")
                                                      ? "${e.A}"
                                                      : (data.tipe_benda == "B")
                                                          ? "${e.B}"
                                                          : "${e.C}",
                                                  FontAwesomeIcons.boxOpen);
                                            }).toList(),
                                          );
                                        }
                                      }
                                      return bodyCard(
                                          blockHorizontal,
                                          blockVertical,
                                          "Stock Amount",
                                          "-",
                                          FontAwesomeIcons.boxOpen);
                                    })
                              ],
                            ),
                          ],
                        ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Production",
                                  style: TextStyle(
                                      fontSize: blockVertical * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                                (data.state == 1)
                                    ? StreamBuilder(
                                        stream: streamProd.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                              children: qList.map((e) {
                                                return NilaiProduction(
                                                    blockHorizontal,
                                                    blockVertical,
                                                    "Processed Unit",
                                                    (e.state == 1)
                                                        ? "${e.processed} Unit"
                                                        : "- Unit",
                                                    "Good Processed",
                                                    (e.state == 1)
                                                        ? "${e.good} Unit"
                                                        : "- Unit",
                                                    "Defect Unit",
                                                    (e.state == 1)
                                                        ? "${e.defect} Unit"
                                                        : "- Unit");
                                              }).toList(),
                                            );
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return ShimmerBody(
                                                blockHorizontal, blockVertical);
                                          }
                                          return NilaiProduction(
                                              blockHorizontal,
                                              blockVertical,
                                              "Processed Unit",
                                              "- Unit",
                                              "Good Processed",
                                              "- Unit",
                                              "Defect Unit",
                                              "- Unit");
                                        })
                                    : NilaiProduction(
                                        blockHorizontal,
                                        blockVertical,
                                        "Processed Unit",
                                        "- Unit",
                                        "Good Processed",
                                        "- Unit",
                                        "Defect Unit",
                                        "- Unit"),
                              ],
                            ),
                            Divider(
                              thickness: blockVertical * 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Production",
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
                                  ],
                                ),
                                (data.state == 1)
                                    ? StreamBuilder(
                                        stream: streamTime.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                              children: aList.map((e) {
                                                return NilaiProduction(
                                                    blockHorizontal,
                                                    blockVertical,
                                                    "Running Time",
                                                    "${(e.runningtime! / 60).toStringAsFixed(2)} Minute",
                                                    "Operation Time",
                                                    "${(e.operationtime! / 60).toStringAsFixed(2)} Minute",
                                                    "Downtime",
                                                    "${(e.downtime! / 60).toStringAsFixed(2)} Minute");
                                              }).toList(),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return ShimmerBody(
                                                blockHorizontal, blockVertical);
                                          }
                                          return NilaiProduction(
                                              blockHorizontal,
                                              blockVertical,
                                              "Running Time",
                                              "- Minute",
                                              "Operation Time",
                                              "- Minute",
                                              "Downtime",
                                              "- Minute");
                                        },
                                      )
                                    : NilaiProduction(
                                        blockHorizontal,
                                        blockVertical,
                                        "Running Time",
                                        "- Minute",
                                        "Operation Time",
                                        "- Minute",
                                        "Downtime",
                                        "- Minute")
                              ],
                            ),
                            Divider(
                              thickness: blockVertical * 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Parameter",
                                  style: TextStyle(
                                      fontSize: blockVertical * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                                StreamBuilder<Object>(
                                    stream: streamParam.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                          children: paramList.map((e) {
                                            return NilaiProduction(
                                                blockHorizontal,
                                                blockVertical,
                                                "Loading Time",
                                                (e.state == 1)
                                                    ? "${e.loading_time} Minute"
                                                    : "- Minute",
                                                "Cycle Time",
                                                (e.state == 1)
                                                    ? "${e.cycle_time} Minute"
                                                    : "- Minute",
                                                "OEE Target",
                                                (e.state == 1)
                                                    ? "${e.oee_target} %"
                                                    : "- %");
                                          }).toList(),
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ShimmerBody(
                                            blockHorizontal, blockVertical);
                                      }
                                      return NilaiProduction(
                                          blockHorizontal,
                                          blockVertical,
                                          "Loading Time",
                                          "- Minute",
                                          "Cycle Time",
                                          "- Minute",
                                          "OEE Target",
                                          "- %");
                                    }),
                              ],
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
                  );
                },
              ).toList(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: blockVertical * 80,
              width: MediaQuerywidth,
              color: Colors.transparent,
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: blockVertical * 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }
          return Center();
        },
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
                        InputDefect.defectQuality(
                            int.parse(jumlah.text), 1, "$tipe");
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

  Widget bodyCard(double blockHorizontal, double blockVertical, String title,
      String Value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: blockVertical * 0.5, horizontal: blockHorizontal * 3),
      height: blockVertical * 6,
      width: blockHorizontal * 42,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(blockVertical * 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Color.fromARGB(255, 100, 100, 100),
                    fontSize: blockVertical * 1.2),
              ),
              Icon(
                icon,
                size: blockVertical * 2,
                color: Colors.grey,
              )
            ],
          ),
          Text(Value,
              style: TextStyle(
                  fontSize: blockVertical * 2, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget statusMesin(double blockHorizontal, double blockVertical, Color colors,
      String title) {
    return Row(
      children: [
        Container(
          height: blockVertical * 1.2,
          width: blockVertical * 1.2,
          color: colors,
        ),
        Text(title,
            style: TextStyle(
                fontSize: blockVertical * 2, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
