import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/main.dart';
import 'package:project_tugas_akhir_copy/newdata/dashboard_app_theme.dart';
// import 'package:project_tugas_akhir_copy/services/preventive_service.dart';
// import 'package:project_tugas_akhir_copy/additional/report_maintenance.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
// import 'package:project_tugas_akhir_copy/drawer.dart';
// import 'package:project_tugas_akhir_copy/models/preventive_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class PreventiveHistory extends StatefulWidget {
  const PreventiveHistory(String aw, {super.key});

  @override
  State<PreventiveHistory> createState() => _PreventiveHistoryState();
}

class _PreventiveHistoryState extends State<PreventiveHistory> {
  late List<DataRow> rows; // State untuk menyimpan baris tabel
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

  final StreamController<List<DataRow>> streamPrev =
      StreamController<List<DataRow>>.broadcast();
  // int m = 1;
  bool sort = false;
  late Timer timer;

  @override
  void initState() {
    getValidUser();
    rows = [];
    // prevData();
    super.initState();
  }

  @override
  void dispose() {
    streamPrev.close();
    super.dispose();
  }

  // Future<void> prevData() async {
  //   // Simulasi data dari API atau sumber data lainnya
  //   List<DataRow> newRows = [
  //     DataRow(cells: [
  //       DataCell(Text('1')),
  //       DataCell(Text('Komponen 1')),
  //       DataCell(Text('Nama Pekerjaan 1')),
  //       DataCell(Text('Checklist 1')),
  //     ]),
  //     DataRow(cells: [
  //       DataCell(Text('2')),
  //       DataCell(Text('Komponen 2')),
  //       DataCell(Text('Nama Pekerjaan 2')),
  //       DataCell(Text('Checklist 2')),
  //     ]),
  //   ];
  //   setState(() {
  //     rows = newRows;
  //   });
  //   streamPrev.add(rows);
  // }

  final timeZone = tz.getLocation('Asia/Jakarta');
  @override
  Widget build(BuildContext context) {
    // UNTUK LEBAR TAMPILAN
    final MediaQuerywidth = MediaQuery.of(context).size.width;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          toolbarHeight: blockVertical * 6,
          shadowColor: Colors.transparent,
          title: Text(
            "Form Preventive Maintenance",
            style: TextStyle(fontSize: blockVertical * 2.5),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 2, 66, 87).withOpacity(0.5),
          leading: backbutton(context),
        ),
        body: Container(
          padding: EdgeInsets.only(top: blockVertical * 12),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 5, 180, 238),
                  Color.fromARGB(255, 1, 37, 53),
                ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "History Scheduled Maintenance",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: blockVertical * 2.5,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: blockVertical * 3),
                height: blockVertical * 82,
                width: MediaQuerywidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: blockVertical * 67.2,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: StreamBuilder<List<DataRow>>(
                            stream: streamPrev.stream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text('No data available'),
                                );
                              }

                              return DataTable(
                                sortColumnIndex: 0,
                                sortAscending: sort,
                                headingRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> state) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5);
                                  },
                                ),
                                border: TableBorder.all(
                                  width: blockVertical * 0.2,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Component",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Work name",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Checklist",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Action",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: blockVertical * 2,
                                      ),
                                    ),
                                  )
                                ],
                                rows: snapshot.data!,
                              );
                            },
                          ),
                          // }),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: blockVertical * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: blockVertical * 0.75,
                          left: blockVertical * 1.5,
                          right: blockVertical * 1.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: SizedBox(
                              width: 38 * 2.0,
                              height: 38 + 62.0,
                              child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: 38 * 2.0,
                                  height: 38 * 2.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // alignment: Alignment.center,s
                                      decoration: BoxDecoration(
                                        color: HexColor('#20b2aa'),
                                        gradient: LinearGradient(
                                            colors: [
                                              HexColor('#20b2aa'),
                                              HexColor('#79d0cc'),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight),
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: HexColor('#20b2aa')
                                                  .withOpacity(0.4),
                                              offset: const Offset(8.0, 16.0),
                                              blurRadius: 16.0),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.1),
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              final newRow = DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text('${rows.length + 1}'),
                                                  ),
                                                  DataCell(
                                                    Text('New Komponen'),
                                                  ),
                                                  DataCell(
                                                    Text('New Pekerjaan'),
                                                  ),
                                                  DataCell(
                                                    Text('New Checklist'),
                                                  ),
                                                ],
                                              );
                                              rows.add(newRow);
                                              streamPrev.add(rows);
                                            });
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: DashboardAppTheme.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: SizedBox(
                              width: 38 * 2.0,
                              height: 38 + 62.0,
                              child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: 38 * 2.0,
                                  height: 38 * 2.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // alignment: Alignment.center,s
                                      decoration: BoxDecoration(
                                        color: DashboardAppTheme.nearlyDarkBlue,
                                        gradient: LinearGradient(
                                            colors: [
                                              DashboardAppTheme.nearlyDarkBlue,
                                              HexColor('#6A88E5'),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight),
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: DashboardAppTheme
                                                  .nearlyDarkBlue
                                                  .withOpacity(0.4),
                                              offset: const Offset(8.0, 16.0),
                                              blurRadius: 16.0),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.1),
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          onTap: () {},
                                          child: Icon(
                                            Icons.save,
                                            color: DashboardAppTheme.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: SizedBox(
                              width: 38 * 2.0,
                              height: 38 + 62.0,
                              child: Container(
                                alignment: Alignment.topCenter,
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: 38 * 2.0,
                                  height: 38 * 2.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // alignment: Alignment.center,s
                                      decoration: BoxDecoration(
                                        color: HexColor('#cc0000'),
                                        gradient: LinearGradient(
                                            colors: [
                                              HexColor('#cc0000'),
                                              HexColor('#e06666'),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight),
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: HexColor('#cc0000')
                                                  .withOpacity(0.4),
                                              offset: const Offset(8.0, 16.0),
                                              blurRadius: 16.0),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.1),
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          onTap: () {},
                                          child: Icon(
                                            Icons.picture_as_pdf,
                                            color: DashboardAppTheme.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
