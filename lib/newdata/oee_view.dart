import 'dart:async';

import 'package:project_tugas_akhir_copy/additional/report_pdf.dart';
import 'package:project_tugas_akhir_copy/main.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';

import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'dart:math' as math;

import 'package:project_tugas_akhir_copy/services/oee_service.dart';
import 'package:shimmer/shimmer.dart';

class OeeView extends StatefulWidget {
  const OeeView({Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  State<OeeView> createState() => _OeeViewState();
}

class _OeeViewState extends State<OeeView> with TickerProviderStateMixin {
  StreamController<List<OEEdashModel>> streamOEE = StreamController.broadcast();
  List<OEEdashModel> oeeList = [];
  GetOEE oee = GetOEE();
  Future<void> oeeData() async {
    oeeList = await GetOEE.dashOEE();
    streamOEE.add(oeeList);
  }

  AnimationController? animationController;
  Animation<double>? animation;
  Timer? timer;
  @override
  void initState() {
    oeeData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      oeeData();
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
    // double blockHorizontal = MediaQuerywidth / 100;
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    return AnimatedBuilder(
      animation: animationController!,
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
                  child: StreamBuilder<List<OEEdashModel>>(
                    stream: streamOEE.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            child: Text("Error Bro: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        List<OEEdashModel> pList = snapshot.data!;
                        return Column(
                          children: pList.map((e) {
                            print('data: ${e}');
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, top: 4),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: 48,
                                                    width: 2,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#87A0E5')
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4,
                                                                  bottom: 2),
                                                          child: Text(
                                                            'OEE',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  DashboardAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  -0.1,
                                                              color: DashboardAppTheme
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 28,
                                                              height: 28,
                                                              child: Image.asset(
                                                                  "images/illustration-business-target-icon.png"),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 4,
                                                                      bottom:
                                                                          3),
                                                              child: (e.state ==
                                                                      1)
                                                                  ? Text(
                                                                      '${((e.nilaioee * 100) * animation!.value).toStringAsFixed(2)}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            DashboardAppTheme.fontName,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            16,
                                                                        color: DashboardAppTheme
                                                                            .darkerText,
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 4,
                                                                      bottom:
                                                                          3),
                                                              child: Text(
                                                                '%',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      DashboardAppTheme
                                                                          .fontName,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      -0.2,
                                                                  color: DashboardAppTheme
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: 48,
                                                    width: 2,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#F56E98')
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4,
                                                                  bottom: 2),
                                                          child: Text(
                                                            'Biglosses',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  DashboardAppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  -0.1,
                                                              color: DashboardAppTheme
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 28,
                                                              height: 28,
                                                              child: Image.asset(
                                                                  "images/burned.png"),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 4,
                                                                      bottom:
                                                                          3),
                                                              child: (e.state ==
                                                                      1)
                                                                  ? Text(
                                                                      '${((100 - (e.nilaioee * 100)) * animation!.value).toStringAsFixed(2)}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            DashboardAppTheme.fontName,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            16,
                                                                        color: DashboardAppTheme
                                                                            .darkerText,
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8,
                                                                      bottom:
                                                                          3),
                                                              child: Text(
                                                                '%',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      DashboardAppTheme
                                                                          .fontName,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      -0.2,
                                                                  color: DashboardAppTheme
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: Center(
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        DashboardAppTheme.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(100.0),
                                                    ),
                                                    border: new Border.all(
                                                        width: 4,
                                                        color: DashboardAppTheme
                                                            .nearlyDarkBlue
                                                            .withOpacity(0.2)),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      (e.state == 1)
                                                          ? Text(
                                                              '${((e.nilaioee * 100) * animation!.value).toStringAsFixed(2)}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    DashboardAppTheme
                                                                        .fontName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 24,
                                                                letterSpacing:
                                                                    0.0,
                                                                color: DashboardAppTheme
                                                                    .nearlyDarkBlue,
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      Text(
                                                        'OEE Result',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              DashboardAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          letterSpacing: 0.0,
                                                          color:
                                                              DashboardAppTheme
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.5),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: CustomPaint(
                                                  painter: CurvePainter(
                                                      colors: [
                                                        DashboardAppTheme
                                                            .nearlyDarkBlue,
                                                        HexColor("#8A98E8"),
                                                        HexColor("#8A98E8")
                                                      ],
                                                      angle: (e.state == 1)
                                                          ? (e.nilaioee * 360) +
                                                              (360 -
                                                                      e.nilaioee *
                                                                          360) *
                                                                  (1.0 -
                                                                      animation!
                                                                          .value)
                                                          : (0 * 360) +
                                                              (360 - 0 * 360) *
                                                                  (1.0 -
                                                                      animation!
                                                                          .value)),
                                                  child: SizedBox(
                                                    width: 108,
                                                    height: 108,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
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
                                            Text(
                                              'Availability',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    DashboardAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.2,
                                                color:
                                                    DashboardAppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#87A0E5')
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: (e.state == 1)
                                                          ? ((70 * e.availability) *
                                                              animation!.value)
                                                          : ((70 * 0) *
                                                              animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              HexColor(
                                                                  '#87A0E5'),
                                                              HexColor(
                                                                      '#87A0E5')
                                                                  .withOpacity(
                                                                      0.5),
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4.0)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: (e.state == 1)
                                                  ? Text(
                                                      '${(e.availability * 100).toStringAsFixed(2)} %',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            DashboardAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: DashboardAppTheme
                                                            .grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    )
                                                  : SizedBox(),
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
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Performance',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        DashboardAppTheme
                                                            .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.2,
                                                    color: DashboardAppTheme
                                                        .darkText,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                  child: Container(
                                                    height: 4,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#F56E98')
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: (e.state == 1)
                                                              ? ((70 * e.performance) *
                                                                  animationController!
                                                                      .value)
                                                              : ((70 * 0) *
                                                                  animationController!
                                                                      .value),
                                                          height: 4,
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  HexColor(
                                                                          '#F56E98')
                                                                      .withOpacity(
                                                                          0.1),
                                                                  HexColor(
                                                                      '#F56E98'),
                                                                ]),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6),
                                                  child: (e.state == 1)
                                                      ? Text(
                                                          '${(e.performance * 100).toStringAsFixed(2)} %',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                DashboardAppTheme
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color:
                                                                DashboardAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                          ),
                                                        )
                                                      : SizedBox(),
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
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Quality',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        DashboardAppTheme
                                                            .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.2,
                                                    color: DashboardAppTheme
                                                        .darkText,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0, top: 4),
                                                  child: Container(
                                                    height: 4,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#F1B440')
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: (e.state == 1)
                                                              ? ((70 * e.quality) *
                                                                  animationController!
                                                                      .value)
                                                              : ((70 * 0) *
                                                                  animationController!
                                                                      .value),
                                                          height: 4,
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  HexColor(
                                                                          '#F1B440')
                                                                      .withOpacity(
                                                                          0.1),
                                                                  HexColor(
                                                                      '#F1B440'),
                                                                ]),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6),
                                                  child: (e.state == 1)
                                                      ? Text(
                                                          '${(e.quality * 100).toStringAsFixed(2)} %',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                DashboardAppTheme
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color:
                                                                DashboardAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                          ),
                                                        )
                                                      : SizedBox(),
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
                  )),
            ),
          ),
        );
      },
    );
  }
}
// class MediterranesnDietView extends StatelessWidget {
//   final AnimationController? animationController;
//   final Animation<double>? animation;

//   const MediterranesnDietView(
//       {Key? key, this.animationController, this.animation})
//       : super(key: key);

// }

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 0});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
