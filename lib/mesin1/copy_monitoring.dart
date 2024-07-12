// ignore_for_file: unused_local_variable

import 'dart:async';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/models/energy_model.dart';
// import 'package:project_tugas_akhir_copy/models/performance_model.dart';
// import 'package:project_tugas_akhir_copy/models/status_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
// import 'package:project_tugas_akhir_copy/services/availability_service.dart';
// import 'package:project_tugas_akhir_copy/services/lifetime_service.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
// import 'package:project_tugas_akhir_copy/mesin1/m1energy_usage.dart';
// import 'package:project_tugas_akhir_copy/mesin1/m1pressure.dart';
// import 'package:project_tugas_akhir_copy/models/availability_model.dart';
// import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_tugas_akhir_copy/services/energy_service.dart';
// import 'package:project_tugas_akhir_copy/services/performance_service.dart';
// import 'package:project_tugas_akhir_copy/services/status_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// import '../services/param_service.dart';
// import '../services/quality_service.dart';
// import '../services/stock_service.dart';
// import '../models/param_model.dart';
// import '../models/stock_model.dart';

class M1monitoring extends StatefulWidget {
  static const nameRoute = '/m1monitoring ';
  const M1monitoring(
    String p, {
    super.key,
  });

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

  bool state = true;
// STREAMCONTROLLER
  late Timer timer;
  StreamController<List<EnergyModel>> streamEnergy =
      StreamController.broadcast();
  List<EnergyModel> energy = [];
  Energy listEnergy = Energy();
  Future<void> get_Energy() async {
    try {
      energy = await listEnergy.getEnergy();
      if (energy.isEmpty) {
        print("Energy Model data is empty");
      } else {
        print("Energy Model data fetched successfully: ${energy.length} items");
      }
      streamEnergy.add(energy);
    } catch (e) {
      streamEnergy.addError(e);
    }
  }

  @override
  void initState() {
    get_Energy();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      get_Energy();
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
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Monitoring Sensor",
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
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: blockVertical * 4),
                        height: blockVertical * 105,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5)),
                            gradient: LinearGradient(
                                end: Alignment.bottomRight,
                                begin: Alignment.topLeft,
                                colors: [
                                  Color.fromARGB(255, 243, 242, 242)
                                      .withOpacity(0.5),
                                  Color.fromARGB(255, 189, 189, 189)
                                      .withOpacity(0.2)
                                ]),
                            borderRadius: BorderRadius.circular(20)),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return StreamBuilder<Object>(
                              stream: streamEnergy.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: energy.map((e) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              content(
                                                  context,
                                                  constraints,
                                                  currents,
                                                  constraints,
                                                  [
                                                    Color.fromARGB(
                                                            255, 214, 209, 209)
                                                        .withOpacity(0.2),
                                                    Color.fromARGB(
                                                            255, 80, 78, 78)
                                                        .withOpacity(0.5)
                                                  ],
                                                  FontAwesomeIcons.bolt,
                                                  "Current",
                                                  "${e.current} A"),
                                              content(
                                                  context,
                                                  constraints,
                                                  voltages,
                                                  constraints,
                                                  [
                                                    Color.fromARGB(
                                                            255, 214, 209, 209)
                                                        .withOpacity(0.2),
                                                    Color.fromARGB(
                                                            255, 80, 78, 78)
                                                        .withOpacity(0.5)
                                                  ],
                                                  FontAwesomeIcons
                                                      .boltLightning,
                                                  "Voltage",
                                                  "${e.voltage} VAC")
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              content(
                                                  context,
                                                  constraints,
                                                  powers,
                                                  constraints,
                                                  [
                                                    Color.fromARGB(
                                                            255, 214, 209, 209)
                                                        .withOpacity(0.2),
                                                    Color.fromARGB(
                                                            255, 80, 78, 78)
                                                        .withOpacity(0.5)
                                                  ],
                                                  FontAwesomeIcons.batteryHalf,
                                                  "Power",
                                                  "${e.power} W"),
                                              content(
                                                  context,
                                                  constraints,
                                                  energies,
                                                  constraints,
                                                  [
                                                    Color.fromARGB(
                                                            255, 214, 209, 209)
                                                        .withOpacity(0.2),
                                                    Color.fromARGB(
                                                            255, 80, 78, 78)
                                                        .withOpacity(0.5)
                                                  ],
                                                  FontAwesomeIcons.carBattery,
                                                  "Energy",
                                                  "${e.energy} KWh")
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              content(
                                                  context,
                                                  constraints,
                                                  frequencies,
                                                  constraints,
                                                  [
                                                    Color.fromARGB(
                                                            255, 214, 209, 209)
                                                        .withOpacity(0.2),
                                                    Color.fromARGB(
                                                            255, 80, 78, 78)
                                                        .withOpacity(0.5)
                                                  ],
                                                  FontAwesomeIcons.signal,
                                                  "Frequency",
                                                  "${e.frequency} Hz"),
                                              content(
                                                  context,
                                                  constraints,
                                                  pfs,
                                                  constraints,
                                                  [
                                                    Color.fromARGB(
                                                            255, 214, 209, 209)
                                                        .withOpacity(0.2),
                                                    Color.fromARGB(
                                                            255, 80, 78, 78)
                                                        .withOpacity(0.5)
                                                  ],
                                                  FontAwesomeIcons.explosion,
                                                  "Power Factor",
                                                  "${e.pf}")
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              content(
                                                  context,
                                                  constraints,
                                                  temperatures,
                                                  constraints,
                                                  (e.temperature < 80)
                                                      ? [
                                                          Color.fromARGB(255,
                                                                  214, 209, 209)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  80, 78, 78)
                                                              .withOpacity(0.5)
                                                        ]
                                                      : [
                                                          Color.fromARGB(255,
                                                                  255, 101, 101)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  255, 0, 0)
                                                              .withOpacity(0.5)
                                                        ],
                                                  FontAwesomeIcons
                                                      .temperatureHalf,
                                                  "Temperature",
                                                  "${e.temperature} C"),
                                              content(
                                                  context,
                                                  constraints,
                                                  pressures,
                                                  constraints,
                                                  (e.pressure! > 4 &&
                                                          e.pressure < 8)
                                                      ? [
                                                          Color.fromARGB(255,
                                                                  214, 209, 209)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  80, 78, 78)
                                                              .withOpacity(0.5)
                                                        ]
                                                      : [
                                                          Color.fromARGB(255,
                                                                  255, 101, 101)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  255, 0, 0)
                                                              .withOpacity(0.5)
                                                        ],
                                                  Icons.air_rounded,
                                                  "Air Pressure",
                                                  "${e.pressure.toStringAsFixed(2)} bar")
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              content(
                                                  context,
                                                  constraints,
                                                  strains,
                                                  constraints,
                                                  (e.strain < 100)
                                                      ? [
                                                          Color.fromARGB(255,
                                                                  214, 209, 209)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  80, 78, 78)
                                                              .withOpacity(0.5)
                                                        ]
                                                      : [
                                                          Color.fromARGB(255,
                                                                  255, 101, 101)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  255, 0, 0)
                                                              .withOpacity(0.5)
                                                        ],
                                                  FontAwesomeIcons
                                                      .weightHanging,
                                                  "Strain",
                                                  "${e.strain}"),
                                              content(
                                                  context,
                                                  constraints,
                                                  vibrations,
                                                  constraints,
                                                  (e.vibration < 300)
                                                      ? [
                                                          Color.fromARGB(255,
                                                                  214, 209, 209)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  80, 78, 78)
                                                              .withOpacity(0.5)
                                                        ]
                                                      : [
                                                          Color.fromARGB(255,
                                                                  255, 101, 101)
                                                              .withOpacity(0.2),
                                                          Color.fromARGB(255,
                                                                  255, 0, 0)
                                                              .withOpacity(0.5)
                                                        ],
                                                  Icons.vibration_rounded,
                                                  "Vibration",
                                                  "${e.vibration}")
                                            ],
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
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
                                  );
                                }
                                return Center(
                                  child: Text("error"),
                                );
                              });
                        }),
                      )
                      //CHART ENERGY--------------------------------------------------------
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(
      BuildContext context,
      dynamic constraints,
      String route,
      dynamic constraints1,
      List<Color> error,
      IconData icon,
      String title,
      String text) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
        maximumSize: MaterialStateProperty.resolveWith<Size>(
            (Set<MaterialState> states) {
          return Size(constraints.maxWidth * 0.5,
              constraints.maxHeight * 0.145); // ukuran tetap tombol
        }),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route,
            arguments: 'dari monitoring sensor');
      },
      child: Container(
        padding:
            EdgeInsets.only(top: blockVertical * 1, bottom: blockVertical * 1),
        height: constraints1.maxHeight * 0.145,
        width: constraints1.maxWidth * 0.43,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: error),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: blockVertical * 3.5,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: blockVertical * 3, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: blockVertical * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: blockVertical * 3, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
