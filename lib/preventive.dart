// ignore_for_file: unused_local_variable

// ignore: depend_on_referenced_packages
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  TextEditingController umur = TextEditingController();
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
            "Preventive Maintenance",
            style: TextStyle(fontSize: blockVertical * 2.5),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 49, 65).withOpacity(0.5),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                FontAwesomeIcons.bars,
                size: blockVertical * 3,
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, mydashboard,
                      arguments: 'dari mesin 1');
                  // ignore: deprecated_member_use
                },
                icon: Icon(FontAwesomeIcons.house)),
          ],
        ),
        drawer: TheDrawer(mode: "Preventive"),
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
                  height: blockVertical * 20,
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
                            fontSize: blockVertical * 3,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: blockVertical * 1.5,
                      ),
                      StreamBuilder(
                          stream: streamLT.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: listLT.map((e) {
                                      return Lifetime(
                                          blockVertical,
                                          blockHorizontal,
                                          "Machine ${e.machine_id}",
                                          (e.timevalue! / 60)
                                              .toStringAsFixed(2),
                                          (e.timevalue! >= 3600)
                                              ? Colors.green
                                              : Colors.red,
                                          e.machine_id!);
                                    }).toList()),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      "Machine 1", "-", Colors.black, 1),
                                  Lifetime(blockVertical, blockHorizontal,
                                      "Machine 2", "-", Colors.black, 2),
                                  Lifetime(blockVertical, blockHorizontal,
                                      "Machine 3", "-", Colors.black, 3),
                                  Lifetime(blockVertical, blockHorizontal,
                                      "Machine 4", "-", Colors.black, 4),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: blockVertical * 1,
                      left: blockVertical * 1,
                      right: blockVertical * 1),
                  height: blockVertical * 66,
                  width: MediaQuerywidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(blockVertical * 2),
                          topRight: Radius.circular(blockVertical * 2))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Maintenance Schedule",
                        style: TextStyle(
                            fontSize: blockVertical * 3,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: blockVertical * 1,
                      ),
                      SizedBox(
                        height: blockVertical * 50,
                        child: StreamBuilder(
                            stream: streamSchedule.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: listSchedule.map((e) {
                                  if (snapshot.hasData) {
                                    return Schedule(
                                        blockVertical,
                                        blockHorizontal,
                                        "Machine ${e.machine_id}",
                                        (e.hari == "1")
                                            ? "Monday, At ${e.jam}.${e.menit} WIB"
                                            : (e.hari == "2")
                                                ? "Tuesday, At ${e.jam}.${e.menit} WIB"
                                                : (e.hari == "3")
                                                    ? "Wednesday, At ${e.jam}.${e.menit} WIB"
                                                    : (e.hari == "4")
                                                        ? "Thursday, At ${e.jam}.${e.menit} WIB"
                                                        : (e.hari == "5")
                                                            ? "Friday, At ${e.jam}.${e.menit} WIB"
                                                            : (e.hari == "6")
                                                                ? "Saturday, At ${e.jam}.${e.menit} WIB"
                                                                : "Sunday, At ${e.jam}.${e.menit} WIB",
                                        e.machine_id!.toInt(),
                                        "${e.jam}",
                                        "${e.menit}",
                                        "${e.hari}");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    Center(
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
                                  }
                                  return Center();
                                }).toList(),
                              );
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, myhistoriPrev,
                              arguments: "blabla");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: blockHorizontal * 3,
                              vertical: blockVertical * 0.5),
                          margin: EdgeInsets.all(blockVertical * 1),
                          alignment: Alignment.center,
                          height: blockVertical * 5,
                          width: MediaQuerywidth,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.green),
                            borderRadius:
                                BorderRadius.circular(blockVertical * 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "See History Maintenance",
                                style: TextStyle(
                                    fontSize: blockVertical * 2.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: blockVertical * 3,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Lifetime(double blockVertical, double blockHorizontal, String title,
      String value, Color colors, int machine_id) {
    return Container(
      margin: EdgeInsets.only(right: blockHorizontal * 5),
      padding: EdgeInsets.only(
          top: blockVertical * 0.5,
          left: blockVertical * 1,
          right: blockVertical * 1),
      height: blockVertical * 12.5,
      width: blockHorizontal * 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(blockVertical * 1),
        color: Color.fromARGB(255, 212, 212, 212).withOpacity(0.3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                                      "Increase Lifetime Machine $machine_id",
                                      style: TextStyle(
                                          fontSize: blockVertical * 2.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: blockVertical * 1.5,
                                    ),
                                    TextField(
                                      controller: umur,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Increase Lifetime (Minute)"),
                                    ),
                                  ],
                                ),
                                btnOkText: "Add",
                                btnOkIcon: FontAwesomeIcons.plus,
                                btnOkOnPress: () {
                                  UpdateLT.updateUmur(
                                      machine_id, (int.parse(umur.text) * 60));
                                },
                                btnCancelIcon: FontAwesomeIcons.ban,
                                btnCancelOnPress: () {})
                            .show();
                      },
                      child: Icon(
                        Icons.add,
                        size: blockVertical * 2.5,
                      ),
                    )
                  : SizedBox()
            ],
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: blockVertical * 2.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: blockVertical * 2,
          ),
          Text(
            "$value Min",
            style: TextStyle(
                fontSize: blockVertical * 2.5,
                fontWeight: FontWeight.bold,
                color: colors),
          )
        ],
      ),
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
