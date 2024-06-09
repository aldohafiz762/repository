import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/energy_service.dart';
import 'package:shimmer/shimmer.dart';
// ignore: implementation_imports
import '../../models/energy_model.dart';

//VOLTAGE------------------------------------------------------------------------------------
class ChartVolt extends StatefulWidget {
  const ChartVolt({
    super.key,
  });

  @override
  State<ChartVolt> createState() => _ChartVoltState();
}

class _ChartVoltState extends State<ChartVolt> {
  StreamController<List> streamVolt = StreamController.broadcast();
  late Timer timer;
  List<VoltModel> voltList = [];
  ChartperEnergy getLatestvolt = ChartperEnergy();
  Future<void> latestvolt() async {
    voltList = await getLatestvolt.getVolt();
    streamVolt.add(voltList);
  }

  List<VoltPoint> get voltage_Point {
    return voltList
        .mapIndexed((index, element) =>
            VoltPoint(x: index.toDouble(), y: element.voltage!.toDouble()))
        .toList();
  }

  @override
  void initState() {
    latestvolt();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      latestvolt();
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
    return StreamBuilder<Object>(
        stream: streamVolt.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color:
                              Color.fromARGB(255, 94, 94, 94).withOpacity(0.5),
                          strokeWidth: 1);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 9, 99, 110),
                        Color.fromARGB(255, 0, 198, 212)
                      ]),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 9, 99, 110).withOpacity(0.4),
                          Color.fromARGB(255, 0, 198, 212).withOpacity(0.4)
                        ]),
                        applyCutOffY: true,
                        cutOffY: 5,
                      ),
                      spots: voltage_Point
                          .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                          .toList(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: blockVertical * 18,
                  width: blockHorizontal * 75,
                  color: Colors.white,
                ),
              ),
            );
          }
          return Center();
        });
  }
}

//CURRENT------------------------------------------------------------------------------------
class Chartcurrent extends StatefulWidget {
  const Chartcurrent({
    super.key,
  });

  @override
  State<Chartcurrent> createState() => _ChartcurrentState();
}

class _ChartcurrentState extends State<Chartcurrent> {
  StreamController<List> streamcurrent = StreamController.broadcast();
  late Timer timer;
  List<CurrentModel> currentList = [];
  ChartperEnergy getLatestcurrent = ChartperEnergy();
  Future<void> latestcurrent() async {
    currentList = await getLatestcurrent.getCurrent();
    streamcurrent.add(currentList);
  }

  List<CurrentPoint> get current_Point {
    return currentList
        .mapIndexed((index, element) =>
            CurrentPoint(x: index.toDouble(), y: element.current!.toDouble()))
        .toList();
  }

  @override
  void initState() {
    latestcurrent();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      latestcurrent();
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
    return StreamBuilder<Object>(
        stream: streamcurrent.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color:
                              Color.fromARGB(255, 94, 94, 94).withOpacity(0.5),
                          strokeWidth: 1);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 9, 99, 110),
                        Color.fromARGB(255, 0, 198, 212)
                      ]),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 9, 99, 110).withOpacity(0.4),
                            Color.fromARGB(255, 0, 198, 212).withOpacity(0.4)
                          ])),
                      spots: current_Point
                          .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                          .toList(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: blockVertical * 18,
                  width: blockHorizontal * 75,
                  color: Colors.white,
                ),
              ),
            );
          }
          return Center();
        });
  }
}

//POWER------------------------------------------------------------------------------------
class Chartpower extends StatefulWidget {
  const Chartpower({
    super.key,
  });

  @override
  State<Chartpower> createState() => _ChartpowerState();
}

class _ChartpowerState extends State<Chartpower> {
  StreamController<List> streampower = StreamController.broadcast();
  late Timer timer;
  List<PowerModel> powerList = [];
  ChartperEnergy getLatestpower = ChartperEnergy();
  Future<void> latestpower() async {
    powerList = await getLatestpower.getPower();
    streampower.add(powerList);
  }

  List<PowerPoint> get power_Point {
    return powerList
        .mapIndexed((index, element) =>
            PowerPoint(x: index.toDouble(), y: element.power!.toDouble()))
        .toList();
  }

  @override
  void initState() {
    latestpower();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      latestpower();
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
    return StreamBuilder<Object>(
        stream: streampower.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color:
                              Color.fromARGB(255, 94, 94, 94).withOpacity(0.5),
                          strokeWidth: 1);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 9, 99, 110),
                        Color.fromARGB(255, 0, 198, 212)
                      ]),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 9, 99, 110).withOpacity(0.4),
                            Color.fromARGB(255, 0, 198, 212).withOpacity(0.4)
                          ])),
                      spots: power_Point
                          .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                          .toList(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: blockVertical * 18,
                  width: blockHorizontal * 75,
                  color: Colors.white,
                ),
              ),
            );
          }
          return Center();
        });
  }
}

//ENERGY------------------------------------------------------------------------------------
class Chartenergy extends StatefulWidget {
  const Chartenergy({
    super.key,
  });

  @override
  State<Chartenergy> createState() => _ChartenergyState();
}

class _ChartenergyState extends State<Chartenergy> {
  StreamController<List> streamenergy = StreamController.broadcast();
  late Timer timer;
  List<EnergiModel> energyList = [];
  ChartperEnergy getLatestenergy = ChartperEnergy();
  Future<void> latestenergy() async {
    energyList = await getLatestenergy.getEnergi();
    streamenergy.add(energyList);
  }

  List<EnergyPoint> get energy_Point {
    return energyList
        .mapIndexed((index, element) =>
            EnergyPoint(x: index.toDouble(), y: element.energy!.toDouble()))
        .toList();
  }

  @override
  void initState() {
    latestenergy();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      latestenergy();
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
    return StreamBuilder<Object>(
        stream: streamenergy.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color:
                              Color.fromARGB(255, 94, 94, 94).withOpacity(0.5),
                          strokeWidth: 1);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 9, 99, 110),
                        Color.fromARGB(255, 0, 198, 212)
                      ]),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 9, 99, 110).withOpacity(0.4),
                            Color.fromARGB(255, 0, 198, 212).withOpacity(0.4)
                          ])),
                      spots: energy_Point
                          .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                          .toList(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: blockVertical * 18,
                  width: blockHorizontal * 75,
                  color: Colors.white,
                ),
              ),
            );
          }
          return Center();
        });
  }
}

//FREQUENCY------------------------------------------------------------------------------------
class Chartfrequency extends StatefulWidget {
  const Chartfrequency({
    super.key,
  });

  @override
  State<Chartfrequency> createState() => _ChartfrequencyState();
}

class _ChartfrequencyState extends State<Chartfrequency> {
  StreamController<List> streamfrequency = StreamController.broadcast();
  late Timer timer;
  List<FrequencyModel> frequencyList = [];
  ChartperEnergy getLatestfrequency = ChartperEnergy();
  Future<void> latestfrequency() async {
    frequencyList = await getLatestfrequency.getFrequency();
    streamfrequency.add(frequencyList);
  }

  List<FrequencyPoint> get frequency_Point {
    return frequencyList
        .mapIndexed((index, element) => FrequencyPoint(
            x: index.toDouble(), y: element.frequency!.toDouble()))
        .toList();
  }

  @override
  void initState() {
    latestfrequency();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      latestfrequency();
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
    return StreamBuilder<Object>(
        stream: streamfrequency.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color:
                              Color.fromARGB(255, 94, 94, 94).withOpacity(0.5),
                          strokeWidth: 1);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 9, 99, 110),
                        Color.fromARGB(255, 0, 198, 212)
                      ]),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 9, 99, 110).withOpacity(0.4),
                            Color.fromARGB(255, 0, 198, 212).withOpacity(0.4)
                          ])),
                      spots: frequency_Point
                          .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                          .toList(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: blockVertical * 18,
                  width: blockHorizontal * 75,
                  color: Colors.white,
                ),
              ),
            );
          }
          return Center();
        });
  }
}

//POWER FACTOR------------------------------------------------------------------------------------
class Chartpf extends StatefulWidget {
  const Chartpf({
    super.key,
  });

  @override
  State<Chartpf> createState() => _ChartpfState();
}

class _ChartpfState extends State<Chartpf> {
  StreamController<List> streampf = StreamController.broadcast();
  late Timer timer;
  List<PfModel> pfList = [];
  ChartperEnergy getLatestpf = ChartperEnergy();
  Future<void> latestpf() async {
    pfList = await getLatestpf.getPf();
    streampf.add(pfList);
  }

  List<PfPoint> get pf_Point {
    return pfList
        .mapIndexed((index, element) =>
            PfPoint(x: index.toDouble(), y: element.pf!.toDouble()))
        .toList();
  }

  @override
  void initState() {
    latestpf();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      latestpf();
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
    return StreamBuilder<Object>(
        stream: streampf.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color:
                              Color.fromARGB(255, 94, 94, 94).withOpacity(0.5),
                          strokeWidth: 1);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 9, 99, 110),
                        Color.fromARGB(255, 0, 198, 212)
                      ]),
                      barWidth: 4,
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 9, 99, 110).withOpacity(0.4),
                            Color.fromARGB(255, 0, 198, 212).withOpacity(0.4)
                          ])),
                      spots: pf_Point
                          .map((e) => FlSpot(e.x.toDouble(), e.y.toDouble()))
                          .toList(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  height: blockVertical * 18,
                  width: blockHorizontal * 75,
                  color: Colors.white,
                ),
              ),
            );
          }
          return Center();
        });
  }
}
