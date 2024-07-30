import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tugas_akhir_copy/additional/chart_energy.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/models/energy_model.dart';
import 'package:project_tugas_akhir_copy/services/energy_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class RiwayatVoltage extends StatefulWidget {
  static const nameRoute = '/voltages';
  const RiwayatVoltage(String ba, {super.key});

  @override
  State<RiwayatVoltage> createState() => _RiwayatVoltageState();
}

class _RiwayatVoltageState extends State<RiwayatVoltage> {
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

  //STREAM CONTROLLER SENSOR
  StreamController<List<VoltModel>> streamVolt = StreamController.broadcast();
  late Timer timer;
  TableperEnergy getLatestvolt = TableperEnergy();

  Future<void> latestvolt() async {
    try {
      List<VoltModel> voltList =
          (await getLatestvolt.getVolt()) as List<VoltModel>;
      if (!streamVolt.isClosed) {
        streamVolt.add(voltList);
      }
    } catch (e) {
      if (!streamVolt.isClosed) {
        streamVolt.addError('Failed to fetch voltage data');
      }
      print('Error fetching current data: $e'); // Add logging for error
    }
  }

  @override
  void initState() {
    super.initState();
    getValidUser();
    latestvolt();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      latestvolt();
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    streamVolt.close();
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
            "Voltages History",
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
                    child: ChartVolt(),
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
                      child: StreamBuilder<List<VoltModel>>(
                        stream: streamVolt.stream,
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
                            List<VoltModel> voltList = snapshot.data!;
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
                              rows: voltList.map((e) {
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
                                  DataCell(SelectableText("${e.voltage}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2))),
                                  DataCell(Row(
                                    children: [
                                      SelectableText(
                                        (e.voltage! > 210 && e.voltage! < 230)
                                            ? "NORMAL"
                                            : "ERROR",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: blockVertical * 2),
                                      ),
                                      CircleAvatar(
                                        radius: blockVertical * 2.5,
                                        backgroundColor: (e.voltage! > 210 &&
                                                e.voltage! < 230)
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
