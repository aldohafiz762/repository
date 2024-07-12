import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tugas_akhir_copy/additional/chart_energy.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/models/energy_model.dart';
import 'package:project_tugas_akhir_copy/services/energy_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class RiwayatEnergy extends StatefulWidget {
  static const nameRoute = '/energies';
  const RiwayatEnergy(String bd, {super.key});

  @override
  State<RiwayatEnergy> createState() => _RiwayatEnergyState();
}

class _RiwayatEnergyState extends State<RiwayatEnergy> {
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
  StreamController<List<EnergiModel>> streamEnergi =
      StreamController.broadcast();
  late Timer timer;
  TableperEnergy getLatestenergy = TableperEnergy();

  Future<void> latestenergy() async {
    try {
      List<EnergiModel> curList = await getLatestenergy.getEnergi();
      if (!streamEnergi.isClosed) {
        streamEnergi.add(curList);
      }
    } catch (e) {
      if (!streamEnergi.isClosed) {
        streamEnergi.addError('Failed to fetch current data');
      }
      print('Error fetching current data: $e'); // Add logging for error
    }
  }

  @override
  void initState() {
    super.initState();
    getValidUser();
    latestenergy();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      latestenergy();
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    streamEnergi.close();
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
            "Energy History",
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
                    child: Chartenergy(),
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
                      child: StreamBuilder<List<EnergiModel>>(
                        stream: streamEnergi.stream,
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
                            List<EnergiModel> curList = snapshot.data!;
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
                                  DataCell(SelectableText("${e.energy}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2))),
                                  DataCell(Row(
                                    children: [
                                      SelectableText(
                                        "NORMAL",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: blockVertical * 2),
                                      ),
                                      CircleAvatar(
                                        radius: blockVertical * 2.5,
                                        backgroundColor: Colors.green,
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
