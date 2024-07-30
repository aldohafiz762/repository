import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/constant.dart';

import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<String> route = <String>[
    mym1oee,
    mym1stock,
    mypreventive,
    mym1monitoring,
    mym1cost
  ];
  List<String> titleText = <String>[
    'OEE',
    'Stock',
    'Maintenance',
    'Sensor',
    'Cost Production'
  ];
  List<String> areaListData = <String>[
    'images/5596.jpg',
    'images/4016257.jpg',
    'images/tech-support-concept-illustration.png',
    'images/20945553.png',
    'images/budget.png'
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 0.7,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(
                    areaListData.length,
                    (int index) {
                      final int count = areaListData.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController?.forward();
                      return AreaView(
                        titleText: titleText[index],
                        route: route[index],
                        imagepath: areaListData[index],
                        animation: animation,
                        animationController: animationController!,
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView(
      {Key? key,
      this.imagepath,
      this.animationController,
      this.animation,
      this.route,
      this.titleText})
      : super(key: key);

  final String? imagepath;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? route;
  final String? titleText;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: DashboardAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: DashboardAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor:
                      DashboardAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {
                    Navigator.pushNamed(context, route!,
                        arguments: 'dari monitoring sensor');
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 16, right: 16),
                        child: Column(
                          children: [
                            Image.asset(imagepath!),
                            Text(
                              titleText!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: DashboardAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: DashboardAppTheme.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
