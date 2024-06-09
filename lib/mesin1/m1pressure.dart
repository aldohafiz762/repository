// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/additional/chart_pressure.dart';
import 'package:project_tugas_akhir_copy/models/pressure_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:project_tugas_akhir_copy/services/pressure_service.dart';
import 'package:shimmer/shimmer.dart';

class M1pressure extends StatefulWidget {
  const M1pressure({super.key});

  @override
  State<M1pressure> createState() => _M1pressureState();
}

class _M1pressureState extends State<M1pressure> {
  late Timer timer;
  final StreamController<List> streamGauge = StreamController.broadcast();
  List<PressureGauge> gaugeData = [];
  GetPressureGauge getPress = GetPressureGauge();
  Future<void> pressGauges() async {
    gaugeData = await getPress.getValue();
    streamGauge.add(gaugeData);
  }

  @override
  void initState() {
    pressGauges();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      pressGauges();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: blockVertical * 1,
                left: blockHorizontal * 1,
                right: blockHorizontal * 1),
            height: blockVertical * 45,
            width: MediaQuerywidth,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(blockVertical * 3)),
            child: StreamBuilder(
                stream: streamGauge.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: gaugeData.map((e) {
                        return SizedBox(
                          height: blockVertical * 45,
                          width: blockVertical * 45,
                          child: SfRadialGauge(
                            title: GaugeTitle(
                                text: "Wind Pressure",
                                textStyle: TextStyle(
                                    fontSize: blockVertical * 3,
                                    fontWeight: FontWeight.bold)),
                            axes: [
                              RadialAxis(
                                minimum: 0,
                                maximum: 16,
                                pointers: [
                                  NeedlePointer(
                                    value: e.value.toDouble(),
                                    enableAnimation: true,
                                  )
                                ],
                                ranges: [
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: e.value.toDouble(),
                                    color: Colors.green,
                                  ),
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                    widget: Text(
                                      "${e.value}",
                                      style: TextStyle(
                                          fontSize: blockVertical * 3,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    positionFactor: 0.5,
                                    angle: 90,
                                  ),
                                  GaugeAnnotation(
                                    widget: Text(
                                      "bar",
                                      style: TextStyle(
                                          fontSize: blockVertical * 1.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    positionFactor: 0.65,
                                    angle: 90,
                                  )
                                ],
                              ),
                            ],
                          ),
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
                  return SfRadialGauge();
                }),
          ),
          SizedBox(
            height: blockVertical * 2,
          ),
          ChartPressure(),
        ],
      ),
    );
  }
}
