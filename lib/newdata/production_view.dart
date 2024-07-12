import 'dart:async';

import 'package:intl/intl.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:project_tugas_akhir_copy/models/status_model.dart';
import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/quality_service.dart';
import 'package:project_tugas_akhir_copy/services/status_service.dart';
import 'package:shimmer/shimmer.dart';

class BodyMeasurementView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const BodyMeasurementView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<BodyMeasurementView> createState() => _BodyMeasurementViewState();
}

class _BodyMeasurementViewState extends State<BodyMeasurementView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  Timer? timer;

  StreamController<List<DashQuality>> streamProd = StreamController.broadcast();
  List<DashQuality> qList = [];
  QualityDash quality = QualityDash();
  Future<void> qualityData() async {
    qList = await QualityDash.dashQualityM();
    streamProd.add(qList);
  }

  StreamController<List<DashStatusModel>> streamStatusM1 =
      StreamController.broadcast();
  List<DashStatusModel> status = [];
  GetStatusDash statusState = GetStatusDash();

  Future<void> getStatus() async {
    try {
      status = await GetStatusDash.fetchStatusData();
      streamStatusM1.add(status);
    } catch (e) {
      streamStatusM1.addError(e);
    }
  }

  @override
  void initState() {
    qualityData();
    getStatus();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      qualityData();
      getStatus();
    });
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = widget.animation ??
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: animationController!,
          curve: Curves.fastOutSlowIn,
        ));

    animationController?.forward();
    // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchData());
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: DashboardAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DashboardAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: StreamBuilder<List<DashQuality>>(
                  stream: streamProd.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List<DashQuality> qList = snapshot.data!;
                      return Column(
                        children: qList.map((e) {
                          print('data: ${e}');
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 8, top: 16),
                                      child: Text(
                                        'Stage',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily:
                                                DashboardAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: -0.1,
                                            color: DashboardAppTheme.darkText),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        StreamBuilder<List<DashStatusModel>>(
                                          stream: streamStatusM1.stream,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Shimmer.fromColors(
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
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      "Error Bro: ${snapshot.error}"));
                                            } else if (snapshot.hasData) {
                                              List<DashStatusModel> sList =
                                                  snapshot.data!;
                                              return Column(
                                                children: sList.map((e) {
                                                  print('data: ${e}');
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 2,
                                                                bottom: 3),
                                                        child: Text(
                                                          (e.status == 1 &&
                                                                  e.setupState ==
                                                                      true &&
                                                                  e.breakdown ==
                                                                      false)
                                                              ? 'Setup'
                                                              : (e.status ==
                                                                          1 &&
                                                                      e.setupState ==
                                                                          false &&
                                                                      e.cylinder ==
                                                                          true &&
                                                                      e.breakdown ==
                                                                          false)
                                                                  ? 'Running'
                                                                  : (e.status == 1 &&
                                                                          e.setupState ==
                                                                              false &&
                                                                          e.cylinder ==
                                                                              false &&
                                                                          e.breakdown ==
                                                                              false)
                                                                      ? 'Stop'
                                                                      : (e.status == 1 &&
                                                                              e.breakdown == true)
                                                                          ? 'Breakdown'
                                                                          : '',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                DashboardAppTheme
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 32,
                                                            color: DashboardAppTheme
                                                                .nearlyDarkBlue,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 4,
                                                                    bottom: 3),
                                                            child: Text(
                                                              (e.lock == false &&
                                                                      e.status ==
                                                                          1)
                                                                  ? "Locked"
                                                                  : (e.lock ==
                                                                              true &&
                                                                          e.status ==
                                                                              1)
                                                                      ? "Unlocked"
                                                                      : "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    DashboardAppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 20,
                                                                color: DashboardAppTheme
                                                                    .nearlyDarkBlue,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8,
                                                                      bottom:
                                                                          8),
                                                              child: (e.lock ==
                                                                          false &&
                                                                      e.status ==
                                                                          1)
                                                                  ? Icon(Icons
                                                                      .lock_outline_rounded)
                                                                  : (e.lock ==
                                                                              true &&
                                                                          e.status ==
                                                                              1)
                                                                      ? Icon(Icons
                                                                          .lock_open)
                                                                      : SizedBox()),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                            } else {
                                              return Center(
                                                  child: Text(
                                                      "No data available"));
                                            }
                                          },
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  color: DashboardAppTheme.grey
                                                      .withOpacity(0.5),
                                                  size: 16,
                                                ),
                                                (e.state == 1)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 4.0),
                                                        child: Text(
                                                          DateFormat(
                                                                  'yyyy-MM-dd HH:mm:ss')
                                                              .format(DateTime.parse(e
                                                                      .updatedAt
                                                                      .toString())
                                                                  .toLocal()),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                DashboardAppTheme
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            letterSpacing: 0.0,
                                                            color:
                                                                DashboardAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, bottom: 14),
                                              child: Text(
                                                'Latest updated',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: DashboardAppTheme
                                                      .fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  letterSpacing: 0.0,
                                                  color: DashboardAppTheme
                                                      .nearlyDarkBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 8, bottom: 8),
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: DashboardAppTheme.background,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 8, bottom: 16),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          (e.state == 1)
                                              ? Text(
                                                  "${(e.defect).toInt()}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        DashboardAppTheme
                                                            .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    letterSpacing: -0.2,
                                                    color: DashboardAppTheme
                                                        .darkText,
                                                  ),
                                                )
                                              : SizedBox(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Text(
                                              'No Good',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    DashboardAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: DashboardAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              (e.state == 1)
                                                  ? Text(
                                                      "${(e.processed).toInt()}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            DashboardAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                        letterSpacing: -0.2,
                                                        color: DashboardAppTheme
                                                            .darkText,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6),
                                                child: Text(
                                                  'Total Product',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        DashboardAppTheme
                                                            .fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: DashboardAppTheme
                                                        .grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              (e.state == 1)
                                                  ? Text(
                                                      "${(e.good).toInt()}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            DashboardAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                        letterSpacing: -0.2,
                                                        color: DashboardAppTheme
                                                            .darkText,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6),
                                                child: Text(
                                                  'Good',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        DashboardAppTheme
                                                            .fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: DashboardAppTheme
                                                        .grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(child: Text("No data available"));
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
