// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ui';
// import 'dart:js_interop';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:project_tugas_akhir_copy/newdata/biglosses_list_view.dart';
import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'package:project_tugas_akhir_copy/newdata/oee_view.dart';
import 'package:project_tugas_akhir_copy/newdata/production_view.dart';
import 'package:project_tugas_akhir_copy/newdata/status_view.dart';
import 'package:project_tugas_akhir_copy/newdata/title_view.dart';
// import 'package:project_tugas_akhir_copy/models/bigloss_model.dart';
// import 'package:project_tugas_akhir_copy/services/bigloss_service.dart';
// import 'package:project_tugas_akhir_copy/services/quality_service.dart';
// import 'package:project_tugas_akhir_copy/services/availability_service.dart';
// import 'package:project_tugas_akhir_copy/services/oee_service.dart';
// import 'package:project_tugas_akhir_copy/services/plant_status.dart';
// import 'package:project_tugas_akhir_copy/models/oee_model.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:project_tugas_akhir_copy/services/status_service.dart';
// import 'package:project_tugas_akhir_copy/constant.dart';
// import 'package:project_tugas_akhir_copy/drawer.dart';
// import 'package:project_tugas_akhir_copy/models/status_model.dart';
// import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:project_tugas_akhir_copy/models/quality_model.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

// class Dashboard extends StatefulWidget {
//   static const nameRoute = '/dashboard';
//   // const Dashboard({String b, this.animationController}) : super(key: key);
//   const Dashboard(String b, {super.key, this.animationController});
//   final AnimationController? animationController;
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
class Dashboard extends StatefulWidget {
  static const nameRoute = '/dashboard';

  const Dashboard(String b, {super.key});

  // final String b;

  // get animationController => null;
  // final AnimationController? animationController;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  double topBarOpacity = 0.0;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  Animation<double>? topBarAnimation;
  late Timer timer;
  // static List<String> xLabels = [
  //   'Setup',
  //   'Breakdown ',
  //   'Stoppage',
  //   'Speed',
  //   'Startup',
  //   'Reject'
  // ];
  // int touchedIndex = -1;
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
  // StreamController<List<DashQuality>> streamProd = StreamController.broadcast();
  // List<DashQuality> qList = [];
  // QualityDash quality = QualityDash();
  // Future<void> qualityData() async {
  //   qList = await QualityDash.dashQualityM();
  //   streamProd.add(qList);
  // }

  //MONITORING OEE
  // StreamController<List<OEEdashModel>> streamOEE = StreamController.broadcast();
  // List<OEEdashModel> oeeList = [];
  // GetOEE oee = GetOEE();
  // Future<void> oeeData() async {
  //   oeeList = await GetOEE.dashOEE();
  //   streamOEE.add(oeeList);
  // }

//STREAM CONTROLLER BIGLOSSES
  // StreamController<List<DashBLModel>> streamBL = StreamController.broadcast();
  // List<DashBLModel> blList = [];
  // DashBL bigloss = DashBL();
  // Future<void> blData() async {
  //   blList = await DashBL.dashBL();
  //   streamBL.add(blList);
  // }

// STREAMCONTROLLER STATUS MESIN
  // StreamController<List<DashStatusModel>> streamStatusM1 =
  //     StreamController.broadcast();
  // List<DashStatusModel> status = [];
  // GetStatusDash statusState = GetStatusDash();

  // Future<void> getStatus() async {
  //   try {
  //     status = await GetStatusDash.fetchStatusData();
  //     streamStatusM1.add(status);
  //   } catch (e) {
  //     streamStatusM1.addError(e);
  //   }
  // }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    getValidUser();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {});
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    super.initState();
  }

  // void _loadData() async {
  //   List<Status1Model> statusList = await readStat();
  //   _dataProvider.addData(statusList);
  // }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the animation controller
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

  final controller = ScrollController();
  double headerOffset = 0.0;
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

  void addAllListData() {
    int count = 7;

    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: _animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: _animationController),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Production today',
        subTxt: '',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: _animationController,
      ),
    );
    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: _animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Overall Equipment Effectiveness',
        subTxt: 'Customize',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _animationController,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: _animationController,
      ),
    );

    listViews.add(
      OeeView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: _animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Six Big Losses',
        subTxt: 'More details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _animationController,
            curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: _animationController,
      ),
    );

    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: _animationController,
                curve: Interval((1 / count) * 6, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: _animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom * 5,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              _animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    // Mengetahui Orientasi Device
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: DashboardAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DashboardAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage((name == 'Aldo')
                                        ? 'images/aldo.png'
                                        : 'images/asset11.png')),
                                SizedBox(
                                  width: blockHorizontal * 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello, ${name}",
                                      style: TextStyle(
                                        color: DashboardAppTheme.darkerText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: blockVertical * 2,
                                      ),
                                    ),
                                    Text(
                                      "${otoritas}",
                                      style: TextStyle(
                                        color: DashboardAppTheme.darkerText,
                                        fontSize: blockVertical * 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_left,
                            //         color: DashboardAppTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     left: 8,
                            //     right: 8,
                            //   ),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Padding(
                            //         padding: const EdgeInsets.only(right: 8),
                            //         child: Icon(
                            //           Icons.calendar_today,
                            //           color: DashboardAppTheme.grey,
                            //           size: 18,
                            //         ),
                            //       ),
                            //       Text(
                            //         '15 May',
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontFamily: DashboardAppTheme.fontName,
                            //           fontWeight: FontWeight.normal,
                            //           fontSize: 18,
                            //           letterSpacing: -0.2,
                            //           color: DashboardAppTheme.darkerText,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_right,
                            //         color: DashboardAppTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
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
        height: constraints.maxHeight * 1,
        width: constraints.maxWidth * 1,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/asset10.png'), fit: BoxFit.cover),
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
                            fontSize: constraints.maxHeight * 0.1)),
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
                    fontSize: constraints.maxHeight * 0.1)),
            Text(Good,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: constraints.maxHeight * 0.1)),
            Text(Defect,
                style: TextStyle(
                    color: Colors.white, fontSize: constraints.maxHeight * 0.1))
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
