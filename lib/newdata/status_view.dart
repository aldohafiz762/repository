import 'dart:async';

import 'package:project_tugas_akhir_copy/main.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/models/status_model.dart';

import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'package:project_tugas_akhir_copy/services/status_service.dart';
import 'package:shimmer/shimmer.dart';

class GlassView extends StatefulWidget {
  const GlassView({Key? key, this.animationController, this.animation})
      : super(key: key);
  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  State<GlassView> createState() => _GlassViewState();
}

class _GlassViewState extends State<GlassView> with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  Timer? timer;
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
    getStatus();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    // Mengetahui Orientasi Device
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 0, bottom: 24),
                    child: StreamBuilder<List<DashStatusModel>>(
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
                              child: Text("Error Bro: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          List<DashStatusModel> pList = snapshot.data!;
                          return Column(
                            children: pList.map((e) {
                              print('data: ${e}');
                              return Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      // height: blockVertical * 5,
                                      // width: blockHorizontal * 7,
                                      decoration: BoxDecoration(
                                        color: HexColor((e.status == 1)
                                            ? "#d9ead3"
                                            : "#f4cccc"),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0)),
                                        // boxShadow: <BoxShadow>[
                                        //   BoxShadow(
                                        //       color: DashboardAppTheme.grey.withOpacity(0.2),
                                        //       offset: Offset(1.1, 1.1),
                                        //       blurRadius: 10.0),
                                        // ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 68,
                                                bottom: 12,
                                                right: 16,
                                                top: 12),
                                            child: Text(
                                              (e.status == 1)
                                                  ? 'Machine : ON'
                                                  : 'Machine : OFF',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily:
                                                    DashboardAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                letterSpacing: 0.0,
                                                color: DashboardAppTheme
                                                    .nearlyDarkBlue
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -12,
                                    left: 0,
                                    child: SizedBox(
                                      width: blockHorizontal * 15,
                                      height: blockVertical * 12,
                                      child: Image.asset((e.status == 1)
                                          ? "images/correct.png"
                                          : "images/wrong.png"),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
// class GlassView extends StatelessWidget {
//   final AnimationController? animationController;
//   final Animation<double>? animation;

//   const GlassView({Key? key, this.animationController, this.animation})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // UNTUK LEBAR TAMPILAN
//     final MediaQuerywidth = MediaQuery.of(context).size.width;
//     double blockHorizontal = MediaQuerywidth / 100;

//     // UNTUK TINGGI TAMPILAN
//     final MediaQueryheight = MediaQuery.of(context).size.height;
//     double blockVertical = MediaQueryheight / 100;

//     // Mengetahui Orientasi Device
//     final bool isLandscape =
//         MediaQuery.of(context).orientation == Orientation.landscape;

//     return AnimatedBuilder(
//       animation: animationController!,
//       builder: (BuildContext context, Widget? child) {
//         return FadeTransition(
//           opacity: animation!,
//           child: new Transform(
//             transform: new Matrix4.translationValues(
//                 0.0, 30 * (1.0 - animation!.value), 0.0),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 24, right: 24, top: 0, bottom: 24),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16),
//                         child: Container(
//                           // height: blockVertical * 5,
//                           // width: blockHorizontal * 7,
//                           decoration: BoxDecoration(
//                             color: HexColor("#d9ead3"),
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8.0),
//                                 bottomLeft: Radius.circular(8.0),
//                                 bottomRight: Radius.circular(8.0),
//                                 topRight: Radius.circular(8.0)),
//                             // boxShadow: <BoxShadow>[
//                             //   BoxShadow(
//                             //       color: DashboardAppTheme.grey.withOpacity(0.2),
//                             //       offset: Offset(1.1, 1.1),
//                             //       blurRadius: 10.0),
//                             // ],
//                           ),
//                           child: Column(
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 68, bottom: 12, right: 16, top: 12),
//                                 child: Text(
//                                   'Machine is not active',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontFamily: DashboardAppTheme.fontName,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 20,
//                                     letterSpacing: 0.0,
//                                     color: DashboardAppTheme.nearlyDarkBlue
//                                         .withOpacity(0.6),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: -12,
//                         left: 0,
//                         child: SizedBox(
//                           width: blockHorizontal * 15,
//                           height: blockVertical * 12,
//                           child: Image.asset(
//                               "images/green-double-circle-check-mark.png"),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
