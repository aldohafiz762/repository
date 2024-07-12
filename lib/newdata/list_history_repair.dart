import 'dart:async';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_tugas_akhir_copy/models/preventive_model.dart';
import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
import 'package:project_tugas_akhir_copy/services/preventive_service.dart';
import 'package:shimmer/shimmer.dart';

class ListHistorySensor extends StatefulWidget {
  const ListHistorySensor(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  @override
  _ListHistorySensorState createState() => _ListHistorySensorState();
}

class _ListHistorySensorState extends State<ListHistorySensor>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  final StreamController<List<PreventiveMessageModel>> streamPreventive =
      StreamController<List<PreventiveMessageModel>>.broadcast();
  List<PreventiveMessageModel> prevList = [];
  final GetAlarmSensor preventive = GetAlarmSensor();

  Future<void> preventiveData() async {
    if (mounted) {
      prevList = await preventive.getPrev(1);
      streamPreventive.add(prevList);
    } else {
      streamPreventive.close();
    }
  }

  double? topBarOpacity = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    preventiveData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      preventiveData();
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    streamPreventive.close();
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
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: blockVertical),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              height: blockVertical * 75,
              child: StreamBuilder<List<PreventiveMessageModel>>(
                stream: streamPreventive.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey,
                      child: const Text(
                        'Loading',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    List<PreventiveMessageModel> prevList = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: prevList.map((e) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ExpansionTileCard(
                              // baseColor: DashboardAppTheme.nearlyWhite,
                              leading: (e.solved == false)
                                  ? CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(FontAwesomeIcons.xmark))
                                  : CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(FontAwesomeIcons.check)),
                              title: Text(
                                e.message!.toString(),
                                style: TextStyle(
                                    fontFamily: DashboardAppTheme.fontName),
                              ),
                              children: <Widget>[
                                const Divider(
                                  thickness: 1.0,
                                  height: 1.0,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      e.keterangan!.toString(),
                                      style: TextStyle(
                                        fontFamily: DashboardAppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22 + 6 - 6,
                                        letterSpacing: 1.2,
                                        color: DashboardAppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.end,
                                  buttonPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        UpdatePreventiveMessage.updateMessage(
                                            e.machine_id!, e.idpreventive!);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 15.0),
                                        minimumSize: Size(120, 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                            width: 4,
                                          ),
                                          Text(
                                            'Solved',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
