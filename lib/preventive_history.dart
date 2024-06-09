import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/preventive_service.dart';
import 'package:project_tugas_akhir_copy/additional/report_maintenance.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/drawer.dart';
import 'package:project_tugas_akhir_copy/models/preventive_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class PreventiveHistory extends StatefulWidget {
  const PreventiveHistory(String aw, {super.key});

  @override
  State<PreventiveHistory> createState() => _PreventiveHistoryState();
}

class _PreventiveHistoryState extends State<PreventiveHistory> {
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

  int m = 1;
  bool sort = true;
  late Timer timer;
  StreamController streamPrev = StreamController.broadcast();
  List<PreventiveMessageModel> ListPrev = [];
  GetPreventive prevList = GetPreventive();
  Future<void> prevData() async {
    ListPrev = await prevList.getPrev(m);
    streamPrev.add(ListPrev);
  }

  @override
  void initState() {
    getValidUser();
    prevData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      prevData();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
    super.dispose();
  }

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
            "History Maintenance",
            style: TextStyle(fontSize: blockVertical * 2.5),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 2, 66, 87).withOpacity(0.5),
          leading: backbutton(context),
          actions: [
            IconButton(
                onPressed: () {
                  if (otoritas == "User-Management" || otoritas == "Admin") {
                    if (m == 1) {
                      ReportMaintenance(mid: 1).Trouble();
                    } else if (m == 2) {
                      ReportMaintenance(mid: 2).Trouble();
                    } else if (m == 3) {
                      ReportMaintenance(mid: 3).Trouble();
                    } else {
                      ReportMaintenance(mid: 4).Trouble();
                    }
                  } else {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "You have no access to perform this action",
                            useRootNavigator: true,
                            autoHide: Duration(milliseconds: 1500))
                        .show();
                  }
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                ))
          ],
        ),
        drawer: TheDrawer(),
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
                          child: StreamBuilder(
                              stream: streamPrev.stream,
                              builder: (context, snapshot) {
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
                                  }),
                                  border: TableBorder(
                                    top: BorderSide(
                                        width: blockVertical * 0.2,
                                        color: Colors.black.withOpacity(0.3)),
                                    left: BorderSide(
                                        width: blockVertical * 0.2,
                                        color: Colors.black.withOpacity(0.3)),
                                    right: BorderSide(
                                        width: blockVertical * 0.2,
                                        color: Colors.black.withOpacity(0.3)),
                                    bottom: BorderSide(
                                        width: blockVertical * 0.2,
                                        color: Colors.black.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(
                                        blockVertical * 2),
                                    verticalInside: BorderSide(
                                      width: blockVertical * 0.2,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    horizontalInside: BorderSide(
                                      width: 3,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ),
                                  columns: [
                                    DataColumn(
                                        onSort: ((ColumnIndex, ascending) {
                                          setState(() {
                                            sort = !sort;
                                          });
                                          onSortId(ColumnIndex, ascending);
                                        }),
                                        label: Text(
                                          "No",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: blockVertical * 2),
                                        )),
                                    DataColumn(
                                        label: Text(
                                      "Id Order",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Machine",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Message",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Info",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Date",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Done Date",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Solved",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Action",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: blockVertical * 2),
                                    )),
                                  ],
                                  rows: ListPrev.map(
                                    (e) {
                                      //No
                                      int index = ListPrev.indexOf(e);
                                      String Number = (index + 1)
                                          .toString()
                                          .padLeft(ListPrev.length
                                              .toString()
                                              .length);
                                      //FORMAT TANGGAL ASIA/JAKARTA
                                      final TScreatedAt =
                                          DateTime.parse(e.createdAt!);
                                      final NowCreatedAt = tz.TZDateTime.from(
                                          TScreatedAt, timeZone);
                                      final TSupdatedAt =
                                          DateTime.parse(e.updatedAt!);
                                      final NowupdatedAt = tz.TZDateTime.from(
                                          TSupdatedAt, timeZone);
                                      final formatter =
                                          DateFormat('dd-MM-yyyy hh:mm:ss a');
                                      final createdAtFix =
                                          formatter.format(NowCreatedAt);
                                      final updatedAtFix =
                                          formatter.format(NowupdatedAt);
                                      return DataRow(cells: [
                                        DataCell(Text(
                                          Number,
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell(Text(
                                          "${e.idpreventive}",
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell(Text(
                                          "${e.machine_id}",
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell(Text(
                                          "${e.message}",
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell(Text(
                                          "${e.keterangan}",
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell(Text(
                                          createdAtFix,
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell(Text(
                                          (e.solved == true)
                                              ? updatedAtFix
                                              : "-",
                                          style: TextStyle(
                                              fontSize: blockVertical * 2),
                                        )),
                                        DataCell((e.solved == true)
                                            ? Icon(
                                                FontAwesomeIcons.check,
                                                size: blockVertical * 2,
                                                color: Colors.green,
                                              )
                                            : Icon(FontAwesomeIcons.x,
                                                size: blockVertical * 2,
                                                color: Colors.red)),
                                        DataCell((otoritas == "Admin" ||
                                                otoritas == "User-Maintenance")
                                            ? (e.solved == false)
                                                ? ElevatedButton(
                                                    onPressed: () {
                                                      UpdatePreventiveMessage
                                                          .updateMessage(
                                                              e.machine_id!,
                                                              e.idpreventive!);
                                                    },
                                                    child: Text(
                                                      "Solve",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              blockVertical *
                                                                  2),
                                                    ))
                                                : Text(
                                                    "Solved",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            blockVertical * 2),
                                                  )
                                            : SizedBox(
                                                width: 1,
                                              )),
                                      ]);
                                    },
                                  ).toList(),
                                );
                              }),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: blockVertical * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: blockVertical * 1.5, left: blockVertical * 1.5),
                      child: Text(
                        "Main Machine",
                        style: TextStyle(
                            fontSize: blockVertical * 3,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // floatingActionButton: FabCircularMenu(
        //     fabOpenIcon: Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //     ),
        //     fabCloseIcon: Icon(
        //       Icons.close,
        //       color: Colors.white,
        //     ),
        //     fabColor: Color.fromARGB(255, 0, 83, 151),
        //     ringColor: Color.fromARGB(255, 211, 211, 211).withOpacity(0.1),
        //     children: <Widget>[
        //       IconButton(
        //           icon: Icon(
        //             FontAwesomeIcons.one,
        //             color: Color.fromARGB(255, 34, 93, 122),
        //           ),
        //           onPressed: () async {
        //             setState(() {
        //               m = 1;
        //             });
        //             await prevData();
        //           }),
        //       IconButton(
        //           icon: Icon(FontAwesomeIcons.two,
        //               color: Color.fromARGB(255, 34, 93, 122)),
        //           onPressed: () async {
        //             setState(() {
        //               m = 2;
        //             });
        //             await prevData();
        //           }),
        //       IconButton(
        //           icon: Icon(FontAwesomeIcons.three,
        //               color: Color.fromARGB(255, 34, 93, 122)),
        //           onPressed: () async {
        //             setState(() {
        //               m = 3;
        //             });
        //             await prevData();
        //           }),
        //       IconButton(
        //           icon: Icon(FontAwesomeIcons.four,
        //               color: Color.fromARGB(255, 34, 93, 122)),
        //           onPressed: () async {
        //             setState(() {
        //               m = 4;
        //             });
        //             await prevData();
        //           })
        //     ]),
      ),
    );
  }

  onSortId(int ColumnIndex, bool ascending) {
    if (ColumnIndex == 0) {
      if (ascending) {
        ListPrev.sort((a, b) => a.idpreventive!.compareTo(b.idpreventive!));
      } else if (ascending == false) {
        ListPrev.sort((a, b) => b.idpreventive!.compareTo(a.idpreventive!));
      }
    }
  }

  // FabCircularMenu(
  //     {required Icon fabOpenIcon,
  //     required Icon fabCloseIcon,
  //     required Color fabColor,
  //     required Color ringColor,
  //     required List<Widget> children}) {}
}
