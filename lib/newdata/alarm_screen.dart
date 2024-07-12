import 'package:flutter/material.dart';
// import 'package:project_tugas_akhir_copy/newdata/area_list_view.dart';
// import 'package:project_tugas_akhir_copy/fitness_app/ui_view/running_view.dart';
// import 'package:project_tugas_akhir_copy/newdata/title_view.dart';
// import 'package:project_tugas_akhir_copy/fitness_app/ui_view/workout_view.dart';
import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'package:project_tugas_akhir_copy/newdata/list_history_sensor.dart';
import 'package:project_tugas_akhir_copy/newdata/list_history_stock.dart';
import 'package:project_tugas_akhir_copy/newdata/list_history_repair.dart';

class AlarmScreen extends StatefulWidget {
  static const nameRoute = '/m1home';

  const AlarmScreen(String c, {super.key});
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  late AnimationController _animationController;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<String> tipeAlarm = ["Sensor", "Repair", "Stock"];
  int currentAlarmIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

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

  void addAllListData() {
    const int count = 1;
    listViews.clear(); // Clear the list before adding new data

    switch (currentAlarmIndex) {
      case 0:
        listViews.add(
          ListHistorySensor(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: _animationController,
                    curve: Interval((1 / count) * 1, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: _animationController,
          ),
        );
        break;
      case 1:
        listViews.add(
          ListHistoryRepair(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: _animationController,
                    curve: Interval((1 / count) * 1, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: _animationController,
          ),
        );
        break;
      case 2:
        listViews.add(
          ListHistoryStock(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: _animationController,
                    curve: Interval((1 / count) * 1, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: _animationController,
          ),
        );
        break;
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void _updateAlarmIndex(bool increment) {
    setState(() {
      if (increment) {
        currentAlarmIndex = (currentAlarmIndex + 1) % tipeAlarm.length;
      } else {
        currentAlarmIndex =
            (currentAlarmIndex - 1 + tipeAlarm.length) % tipeAlarm.length;
      }
      addAllListData(); // Add this to update the list when the alarm type changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 29, 206, 215),
              Color.fromARGB(255, 19, 78, 227),
            ]),
      ),
      // color: DashboardAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
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
              // bottom: 62 + MediaQuery.of(context).padding.bottom,
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Alarm History',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: DashboardAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: DashboardAppTheme.nearlyWhite,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  _updateAlarmIndex(false);
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: DashboardAppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    tipeAlarm[currentAlarmIndex],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: DashboardAppTheme.fontName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                      letterSpacing: -0.2,
                                      color: DashboardAppTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {
                                  _updateAlarmIndex(true);
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: DashboardAppTheme.white,
                                  ),
                                ),
                              ),
                            ),
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
}
