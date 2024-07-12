import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/newdata/akun_screen.dart';
import 'package:project_tugas_akhir_copy/newdata/alarm_screen.dart';
import 'package:project_tugas_akhir_copy/newdata/bottom_bar_view.dart';
import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'package:project_tugas_akhir_copy/newdata/menu_screen.dart';
import 'package:project_tugas_akhir_copy/newdata/tabIcon_data.dart';
import 'package:project_tugas_akhir_copy/dashboard.dart';
// import 'package:project_tugas_akhir_copy/fitness_app/training/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/report.dart';
// import 'bottom_navigation_view/bottom_bar_view.dart';
// import 'fitness_app_theme.dart';
// import 'my_diary/my_diary_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  static const nameRoute = '/home';

  const FitnessAppHomeScreen(String xo, {super.key});
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  // String? b;
  Widget tabBody = Container(
    color: DashboardAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = Dashboard('b');
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            Navigator.pushNamed(context, mym1home,
                arguments: 'dari monitoring sensor');
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = Dashboard('b');
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = Report('hk');
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = AlarmScreen('c');
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = AkunScreen('de');
                });
              });
            }
          },
        ),
      ],
    );
  }
}
