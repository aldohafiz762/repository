// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/services/status_service.dart';
import 'package:project_tugas_akhir_copy/drawer.dart';
import 'package:project_tugas_akhir_copy/models/status_model.dart';
import 'package:project_tugas_akhir_copy/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../constant.dart';

class M1home extends StatefulWidget {
  static const nameRoute = '/m1home';

  const M1home(String c, {super.key});

  @override
  State<M1home> createState() => _M1homeState();
}

class _M1homeState extends State<M1home> {
  int? state;
  //STREAMCONTROLLER STATUS MESIN
  StreamController<List> streamStatusM1 = StreamController.broadcast();
  List<Status1Model> status = [];
  GetStatusM1 statusState = GetStatusM1();
  Future<void> getStatus() async {
    status = await GetStatusM1.readStatM1();
    streamStatusM1.add(status);
  }

  late Timer timer;
  int id = 0;
  double sizedheight = 20;
  double blurshadow = 10;

  @override
  void initState() {
    getStatus();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getStatus();
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
    // Mengetahui Orientasi Device
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        //APPBAR------------------------------------------------------------------------------------
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          toolbarHeight: blockVertical * 6,
          shadowColor: Colors.transparent,
          title: Text(
            "Main Machine",
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 6, 160, 207).withOpacity(0.5),
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
                icon: Icon(FontAwesomeIcons.house))
          ],
        ),
        //DRAWER------------------------------------------------------------------------------------
        drawer: TheDrawer(mode: "Mesin1"),
        //BODY---------------------------------------------------------------------------------------------------------------------------------
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("images/asset13.jpg"), fit: BoxFit.cover)),
          child: Container(
            padding: EdgeInsets.only(top: blockVertical * 8),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                    colors: [
                  Color.fromARGB(255, 26, 26, 26).withOpacity(0.9),
                  Color.fromARGB(255, 117, 117, 117).withOpacity(0.85)
                ])),
            child: ListView(
              padding: EdgeInsets.fromLTRB(blockHorizontal * 2,
                  blockVertical * 3, blockHorizontal * 2, blockVertical * 0.1),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: blockHorizontal * 2,
                      vertical: blockVertical * 2),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: MediaQuerywidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    offset: Offset(5, 10),
                                    blurRadius: 10)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 13, 89, 177),
                                    Color.fromARGB(255, 58, 169, 203),
                                  ])),
                          child: StreamBuilder<Object>(
                              stream: streamStatusM1.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: status.map((e) {
                                      return Text(
                                        (e.status == 1)
                                            ? "Main Machine - is Active"
                                            : "Main Machine - is Not Active",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }).toList(),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.grey,
                                    child: Text(
                                      'Loading',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: blockVertical * 2.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                                return Text("error");
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                Listmenu1((context), "Input Parameter", mym1param,
                    "from mesin 1", Icons.add_box),
                SizedBox(height: sizedheight),
                Listmenu1((context), "Cost Price", mym1cost, "from mesin 1",
                    Icons.price_change),
                SizedBox(height: sizedheight),
                Listmenu1((context), "OEE", mym1oee, "from mesin 1",
                    FontAwesomeIcons.chartPie),
                SizedBox(height: sizedheight),
                Listmenu1((context), "Monitoring", mym1monitoring,
                    "from mesin 1", FontAwesomeIcons.computer),
                SizedBox(height: sizedheight),
                Listmenu1((context), "Stock", mym1stock, "from mesin 1",
                    FontAwesomeIcons.boxOpen),
                SizedBox(height: sizedheight),
                Listmenu1((context), "Troubleshoot", mym1alarm, "from mesin 1",
                    FontAwesomeIcons.solidBell),
                SizedBox(height: sizedheight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MODEL LIST MENU HALAMAN MESIN 1--------------------------------------------------------------------------------------------------------
  Widget Listmenu1(BuildContext context, String title, String navigate,
      String arg, IconData icon) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 2, 61, 77),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(10, 10),
              blurRadius: blurshadow,
            )
          ]),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        trailing: Icon(
          Icons.arrow_right,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.pushNamed(context, navigate, arguments: arg);
        },
      ),
    );
  }

  Widget Menu(BuildContext context, String title, String navigate, String arg,
      IconData icon, double blockHorizontal, double blockVertical) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 2, 61, 77),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(10, 10),
              blurRadius: blurshadow,
            )
          ]),
    );
  }
}
