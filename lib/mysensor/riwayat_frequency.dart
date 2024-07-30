import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tugas_akhir_copy/additional/chart_energy.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/models/energy_model.dart';
import 'package:project_tugas_akhir_copy/services/energy_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class RiwayatFrequency extends StatefulWidget {
  static const nameRoute = '/frequencies';
  const RiwayatFrequency(String be, {super.key});

  @override
  State<RiwayatFrequency> createState() => _RiwayatFrequencyState();
}

class _RiwayatFrequencyState extends State<RiwayatFrequency> {
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

  late Timer timer;
  //STREAM CONTROLLER SENSOR
  StreamController<List<FrequencyModel>> streamFreq =
      StreamController.broadcast();

  TableperEnergy getLatestfreq = TableperEnergy();

  Future<void> latestfreq() async {
    try {
      List<FrequencyModel> freqList =
          (await getLatestfreq.getFrequency()) as List<FrequencyModel>;
      if (!streamFreq.isClosed) {
        streamFreq.add(freqList);
      }
    } catch (e) {
      if (!streamFreq.isClosed) {
        streamFreq.addError('Failed to fetch frequency data');
      }
      print('Error fetching frequency data: $e'); // Add logging for error
    }
  }

  @override
  void initState() {
    super.initState();
    getValidUser();
    latestfreq();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      latestfreq();
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    streamFreq.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    // double blockHorizontal = MediaQuerywidth / 100;
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Frequency History",
            style: TextStyle(fontSize: blockVertical * 2.5),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 6, 160, 207),
          toolbarHeight: blockVertical * 8,
          leading: backbutton(context),
          shadowColor: Colors.transparent,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 29, 206, 215),
                  Color.fromARGB(255, 19, 78, 227),
                ]),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 100),
                    width: MediaQuerywidth * 1.5,
                    child: Chartfrequency(),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: blockVertical * 55,
                    width: MediaQuerywidth * 1.2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: StreamBuilder<List<FrequencyModel>>(
                        stream: streamFreq.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
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
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            List<FrequencyModel> curList = snapshot.data!;
                            return DataTable(
                              sortColumnIndex: 0,
                              sortAscending: true,
                              border: TableBorder(
                                verticalInside: BorderSide(
                                  width: 3,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                                horizontalInside: BorderSide(
                                  width: 3,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    "Timestamp",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Value",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "State",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2),
                                  ),
                                ),
                              ],
                              rows: curList.map((e) {
                                // Ubah createdAt menjadi waktu lokal
                                DateTime localTime =
                                    DateTime.parse(e.createdAt.toString())
                                        .toLocal();
                                String formattedTime =
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(localTime);

                                return DataRow(cells: [
                                  DataCell(SelectableText(
                                    formattedTime,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2),
                                  )),
                                  DataCell(SelectableText("${e.frequency}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2))),
                                  DataCell(Row(
                                    children: [
                                      SelectableText(
                                        (e.frequency! > 47.5 &&
                                                e.frequency < 52.5)
                                            ? "NORMAL"
                                            : "ERROR",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: blockVertical * 2),
                                      ),
                                      CircleAvatar(
                                        radius: blockVertical * 2.5,
                                        backgroundColor: (e.frequency! > 47.5 &&
                                                e.frequency < 52.5)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  )),
                                ]);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
