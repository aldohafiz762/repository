// ignore_for_file: unused_local_variable

// ignore: depend_on_referenced_packages
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/newdata/biglosses_app_theme.dart';
import 'package:project_tugas_akhir_copy/services/lifetime_service.dart';
import 'package:project_tugas_akhir_copy/services/preventive_service.dart';
import 'package:project_tugas_akhir_copy/constant.dart';
import 'package:project_tugas_akhir_copy/models/lifetime_model.dart';
import 'package:project_tugas_akhir_copy/models/preventive_model.dart';
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/drawer.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preventive extends StatefulWidget {
  static const nameRoute = '/preventive';

  const Preventive(String h, {super.key});

  @override
  State<Preventive> createState() => _PreventiveState();
}

class _PreventiveState extends State<Preventive> {
  TextEditingController umur_jam = TextEditingController();
  TextEditingController umur_menit = TextEditingController();
  TextEditingController umur_detik = TextEditingController();
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
  StreamController streamLT = StreamController.broadcast();
  List<LifetimeModel> listLT = [];
  GetAllLT lifetime = GetAllLT();
  Future<void> lifetimeData() async {
    listLT = await lifetime.getAll();
    streamLT.add(listLT);
  }

  StreamController streamSchedule = StreamController.broadcast();
  List<PreventiveScheduleModel> listSchedule = [];
  GetJadwalPrev getJadwal = GetJadwalPrev();
  Future<void> scheduleData() async {
    listSchedule = await getJadwal.getJadwal();
    streamSchedule.add(listSchedule);
  }

  String? hariValue, jamValue, menitValue;
  bool state = true;
  TextEditingController jam = TextEditingController();
  TextEditingController menit = TextEditingController();
  final List<String> hari = <String>[
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  @override
  void initState() {
    getValidUser();
    scheduleData();
    lifetimeData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      lifetimeData();
      scheduleData();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel();
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
            "Maintenance",
            style: TextStyle(
                fontSize: blockVertical * 3,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 49, 65).withOpacity(0.5),
          leading: backbutton(context),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.pushReplacementNamed(context, mydashboard,
          //             arguments: 'dari mesin 1');
          //         // ignore: deprecated_member_use
          //       },
          //       icon: Icon(FontAwesomeIcons.house)),
          // ],
        ),
        // drawer: TheDrawer(mode: "Preventive"),
        body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(blockVertical * 1),
                  margin: EdgeInsets.fromLTRB(
                      blockHorizontal * 2,
                      blockVertical * 12,
                      blockHorizontal * 2,
                      blockVertical * 2),
                  width: MediaQuerywidth,
                  height: blockVertical * 75,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(blockVertical * 2)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Life Time Machine",
                        style: TextStyle(
                            fontFamily: DashboardAppTheme.fontName,
                            fontSize: blockVertical * 3,
                            fontWeight: FontWeight.bold,
                            color: DashboardAppTheme.nearlyBlack),
                      ),
                      SizedBox(
                        height: blockVertical * 1.5,
                      ),
                      Container(
                        // padding: EdgeInsets.all(8),
                        height: blockVertical * 65,
                        child: StreamBuilder(
                            stream: streamLT.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: listLT.map((e) {
                                        String toDateTime(int value) {
                                          final duration =
                                              Duration(seconds: value);
                                          final hours = duration.inHours;
                                          final minutes =
                                              duration.inMinutes.remainder(60);
                                          final seconds =
                                              duration.inSeconds.remainder(60);
                                          return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Lifetime(
                                              blockVertical,
                                              blockHorizontal,
                                              "${e.name}",
                                              "${toDateTime(e.timevalue)}",
                                              e.timevalue.toInt(),
                                              (e.timevalue! >= 86400)
                                                  ? Colors.green
                                                  : Colors.red,
                                              e.komponen_id!),
                                        );
                                      }).toList()),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      LifetimeShimmmer(
                                          blockVertical, blockHorizontal),
                                      LifetimeShimmmer(
                                          blockVertical, blockHorizontal),
                                      LifetimeShimmmer(
                                          blockVertical, blockHorizontal),
                                      LifetimeShimmmer(
                                          blockVertical, blockHorizontal),
                                    ],
                                  ),
                                );
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Lifetime(blockVertical, blockHorizontal,
                                        "Machine 1", "-", 0, Colors.black, 1),
                                    Lifetime(blockVertical, blockHorizontal,
                                        "Machine 2", "-", 0, Colors.black, 2),
                                    Lifetime(blockVertical, blockHorizontal,
                                        "Machine 3", "-", 0, Colors.black, 3),
                                    Lifetime(blockVertical, blockHorizontal,
                                        "Machine 4", "-", 0, Colors.black, 4),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: blockVertical * 12,
                //   // width: blockHorizontal * 15,
                //   child: StreamBuilder(
                //       stream: streamSchedule.stream,
                //       builder: (context, snapshot) {
                //         return Column(
                //           children: listSchedule.map((e) {
                //             if (snapshot.hasData) {
                //               return Schedule(
                //                   blockVertical,
                //                   blockHorizontal,
                //                   "Machine Press",
                //                   (e.hari == "1")
                //                       ? "Monday, At ${e.jam}.${e.menit} WIB"
                //                       : (e.hari == "2")
                //                           ? "Tuesday, At ${e.jam}.${e.menit} WIB"
                //                           : (e.hari == "3")
                //                               ? "Wednesday, At ${e.jam}.${e.menit} WIB"
                //                               : (e.hari == "4")
                //                                   ? "Thursday, At ${e.jam}.${e.menit} WIB"
                //                                   : (e.hari == "5")
                //                                       ? "Friday, At ${e.jam}.${e.menit} WIB"
                //                                       : (e.hari == "6")
                //                                           ? "Saturday, At ${e.jam}.${e.menit} WIB"
                //                                           : "Sunday, At ${e.jam}.${e.menit} WIB",
                //                   e.machine_id!.toInt(),
                //                   "${e.jam}",
                //                   "${e.menit}",
                //                   "${e.hari}");
                //             } else if (snapshot.connectionState ==
                //                 ConnectionState.waiting) {
                //               Center(
                //                 child: Shimmer.fromColors(
                //                   baseColor: Colors.white,
                //                   highlightColor: Colors.grey,
                //                   child: Text(
                //                     'Loading',
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                       fontSize: blockVertical * 5,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             }
                //             return Center();
                //           }).toList(),
                //         );
                //       }),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Lifetime(double blockVertical, double blockHorizontal, String title,
      String value, int nextMaintain, Color colors, int komponen_id) {
    DateTime nextMaintenanceDate =
        DateTime.now().add(Duration(seconds: nextMaintain));
    return Container(
      // margin: EdgeInsets.only(right: blockHorizontal * 0),
      padding: EdgeInsets.only(
          top: blockVertical * 0.5,
          left: blockVertical * 1,
          right: blockVertical * 1),
      height: blockVertical * 12.5,
      width: blockHorizontal * 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(blockVertical * 1),
        color: (komponen_id == 1 ||
                komponen_id == 2 ||
                komponen_id == 3 ||
                komponen_id == 4)
            ? Colors.red[200]?.withOpacity(0.3)
            : (komponen_id == 5 || komponen_id == 6)
                ? Colors.yellow[200]?.withOpacity(0.3)
                : Colors.green[200]?.withOpacity(0.3),
      ),
      child:
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: blockVertical * 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(
              //   height: blockVertical * 2,
              // ),
              Text(
                "$value",
                style: TextStyle(
                    fontSize: blockVertical * 2.5,
                    fontWeight: FontWeight.bold,
                    color: colors),
              ),
              Text(
                "Next Maintenance at :",
                style: TextStyle(
                    fontSize: blockVertical * 2,
                    fontWeight: FontWeight.bold,
                    color: DashboardAppTheme.darkText),
              ),
              Text(
                "${nextMaintenanceDate.day} / ${nextMaintenanceDate.month} / ${nextMaintenanceDate.year}",
                style: TextStyle(
                    fontSize: blockVertical * 2.5,
                    fontWeight: FontWeight.bold,
                    color: DashboardAppTheme.darkText),
              ),
            ],
          ),
          (otoritas == "Admin" || otoritas == "User-Maintenance")
              ? GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        useRootNavigator: true,
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Increase Lifetime $title",
                              style: TextStyle(
                                  fontSize: blockVertical * 2.5,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: blockVertical * 1.5,
                            ),
                            TextField(
                              controller: umur_jam,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: "Hour"),
                            ),
                            TextField(
                              controller: umur_menit,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: "Minute"),
                            ),
                            TextField(
                              controller: umur_detik,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: "Second"),
                            ),
                          ],
                        ),
                        btnOkText: "Add",
                        btnOkIcon: FontAwesomeIcons.plus,
                        btnOkOnPress: () {
                          int hours = umur_jam.text.isNotEmpty
                              ? int.parse(umur_jam.text)
                              : 0;
                          int minutes = umur_menit.text.isNotEmpty
                              ? int.parse(umur_menit.text)
                              : 0;
                          int seconds = umur_detik.text.isNotEmpty
                              ? int.parse(umur_detik.text)
                              : 0;

                          int totalSeconds =
                              (hours * 3600) + (minutes * 60) + seconds;

                          UpdateLT.updateUmur(komponen_id, totalSeconds);
                          // Clear the text fields after adding the lifetime
                          umur_jam.clear();
                          umur_menit.clear();
                          umur_detik.clear();
                        },
                        btnCancelIcon: FontAwesomeIcons.ban,
                        btnCancelOnPress: () {
                          // Clear the text fields after adding the lifetime
                          umur_jam.clear();
                          umur_menit.clear();
                          umur_detik.clear();
                        }).show();
                  },
                  child: ClipOval(
                    // padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: blockVertical * 7,
                      width: blockVertical * 7,
                      color: Colors.white,
                      child: Icon(FontAwesomeIcons.plus),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),

      // ],
      // ),
    );
  }

  Widget LifetimeShimmmer(
    double blockVertical,
    double blockHorizontal,
  ) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 211, 211, 211),
      highlightColor: Colors.white,
      child: Container(
        margin: EdgeInsets.only(right: blockHorizontal * 5),
        padding: EdgeInsets.only(
            top: blockVertical * 0.5,
            left: blockVertical * 1,
            right: blockVertical * 1),
        height: blockVertical * 12.5,
        width: blockHorizontal * 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(blockVertical * 1),
          color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.3),
        ),
      ),
    );
  }

  Widget Schedule(
      double blockVertical,
      double blockHorizontal,
      String title,
      String subtitle,
      int id,
      String jamValues,
      String menitValues,
      String hariValues) {
    return Container(
      margin: EdgeInsets.only(bottom: blockVertical * 1),
      alignment: Alignment.center,
      height: blockVertical * 10,
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(blockVertical * 1)),
      child: ListTile(
        isThreeLine: true,
        tileColor: Colors.blue.withOpacity(0.5),
        leading: Icon(
          Icons.calendar_month,
          color: Colors.black87,
          size: blockVertical * 4,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: blockVertical * 2.5),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: blockVertical * 2, color: Colors.black87),
        ),
        trailing: (otoritas == "Admin" || otoritas == "User-Maintenance")
            ? IconButton(
                onPressed: () {
                  AwesomeDialog(
                    dialogType: DialogType.noHeader,
                    context: context,
                    body: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: blockVertical * 0.1,
                              horizontal: blockHorizontal * 1),
                          child: DropdownSearch<String>(
                            clearButtonProps: ClearButtonProps(
                              isVisible: true,
                            ),
                            popupProps: PopupProps.menu(
                              constraints: BoxConstraints(
                                maxHeight: blockVertical * 30,
                              ),
                              showSelectedItems: true,
                            ),
                            items: hari,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Select Day",
                                hintText: "Day",
                              ),
                            ),
                            onChanged: (value) {
                              hariValue = value;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: blockVertical * 4,
                                width: blockHorizontal * 20,
                                child: TextField(
                                  controller: jam,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: blockVertical * 3),
                                  readOnly: true,
                                )),
                            Text(
                              ":",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 3),
                            ),
                            SizedBox(
                                height: blockVertical * 4,
                                width: blockHorizontal * 20,
                                child: TextField(
                                  controller: menit,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: blockVertical * 3),
                                  readOnly: true,
                                )),
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                // Mengisi nilai jam dan menit ke dalam TextFormField
                                jam.text = pickedTime.hour.toString();
                                menit.text = pickedTime.minute.toString();
                              }
                            },
                            child: Text("Select Time"))
                      ],
                    ),
                    btnOkOnPress: () {
                      UpdateJadwalPreventive.updateJadwal(
                          id.toInt(),
                          (hariValue == "Senin")
                              ? "1"
                              : (hariValue == "Selasa")
                                  ? "2"
                                  : (hariValue == "Rabu")
                                      ? "3"
                                      : (hariValue == "Kamis")
                                          ? "4"
                                          : (hariValue == "Jumat")
                                              ? "5"
                                              : (hariValue == "Sabtu")
                                                  ? "6"
                                                  : "7",
                          jam.text.toString(),
                          menit.text.toString());
                    },
                    btnCancelOnPress: () {},
                    useRootNavigator: true,
                  ).show();
                },
                icon: Icon(
                  Icons.edit,
                  size: blockVertical * 4,
                  color: Colors.black87,
                ))
            : SizedBox(
                width: 1,
              ),
      ),
    );
  }
}
