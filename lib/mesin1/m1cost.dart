// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/main.dart';
import 'package:project_tugas_akhir_copy/services/costprice_service.dart';
import 'package:project_tugas_akhir_copy/back_button_pop.dart';
import 'package:project_tugas_akhir_copy/additional/mpricelist.dart';
import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class M1cost extends StatefulWidget {
  static const nameRoute = '/m1cost';
  const M1cost(String k, {super.key});

  // static const List<Tab> myTabs = [
  //   Tab(
  //     text: "Production",
  //     icon: Icon(FontAwesomeIcons.productHunt),
  //   ),
  //   Tab(
  //     text: "Price List",
  //     icon: Icon(FontAwesomeIcons.moneyBillWave),
  //   ),
  // ];
  @override
  State<M1cost> createState() => _M1costState();
}

class _M1costState extends State<M1cost> {
  late Timer timer;
  //LATEST COST
  StreamController streamCost = StreamController.broadcast();
  List<GetCostModel> listCost = [];
  GetLatestCost latestCost = GetLatestCost();
  Future<void> CostData() async {
    listCost = await latestCost.getCostList(1);
    streamCost.add(listCost);
  }

  StreamController streamCostH = StreamController.broadcast();
  List<GetCostHModel> listCostH = [];
  GetCostHistori latestCostH = GetCostHistori();
  Future<void> CostHData() async {
    listCostH = await latestCostH.getCostH(1);
    streamCostH.add(listCostH);
  }

  @override
  void initState() {
    CostHData();
    CostData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      CostHData();
      CostData();
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
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;

    // UNTUK TINGGI TAMPILAN
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Cost Price",
            style: TextStyle(
                fontSize: blockVertical * 3,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 6, 160, 207),
          toolbarHeight: blockVertical * 8,
          leading: backbutton(context),
          // bottom: TabBar(
          //   tabs: M1cost.myTabs,
          //   indicatorColor: Colors.white,
          //   indicatorWeight: 3,
          //   indicatorPadding: EdgeInsets.all(5),
          // ),
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
          child: Production(blockHorizontal, blockVertical),
          // M1pricelist()
          // ]),
        ),
      ),
      // ),
    );
  }

  Widget listHistory(BuildContext context, String good, String tanggal,
      String total, IconData icon) {
    final MediaQuerywidth = MediaQuery.of(context).size.width;
    double blockHorizontal = MediaQuerywidth / 100;
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: blockHorizontal * 2, vertical: blockVertical * 0.5),
      child: Container(
        height: blockVertical * 10,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 9, 241, 129).withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuerywidth,
        child: ListTile(
          title: Text(
            good,
            style: TextStyle(
                fontSize: blockVertical * 2.5, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            tanggal.split(" ")[0],
            style: TextStyle(fontSize: blockVertical * 2),
          ),
          leading: Icon(
            icon,
            size: blockVertical * 3,
            color: Colors.black,
          ),
          tileColor: Color.fromARGB(255, 5, 209, 111),
          trailing: Text(
            total,
            style: TextStyle(
                fontSize: blockVertical * 2.5, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget Production(double blockHorizontal, double blockVertical) {
    return Padding(
      padding: EdgeInsets.only(top: blockVertical * 2.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD COST PRICE-------------------------------------------------------------------------------------------------------------------------
            StreamBuilder(
              stream: streamCost.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: listCost.map((e) {
                      String toDateTime(int value) {
                        final duration = Duration(seconds: value);
                        final hours = duration.inHours;
                        final minutes = duration.inMinutes.remainder(60);
                        final seconds = duration.inSeconds.remainder(60);
                        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                      }

                      dynamic tarif_listrik =
                          e.daya * e.tarif_kwh * (e.waktu / 3600);
                      dynamic upah = e.manpower! * (e.waktu / 3600);
                      int harga_total = e.good! * e.harga_unit!;
                      dynamic harga_produksi =
                          tarif_listrik + upah + harga_total;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              baris1(
                                  blockHorizontal,
                                  blockVertical,
                                  "Date",
                                  (e.state == 1)
                                      ? (e.tanggal!).split(",")[0]
                                      : "-",
                                  Color.fromARGB(255, 202, 108, 0)),
                              baris1(
                                  blockHorizontal,
                                  blockVertical,
                                  "HPP",
                                  (e.state == 1)
                                      ? "Rp.${e.total_harga.toStringAsFixed(2)},-"
                                      : "-",
                                  Color.fromARGB(255, 197, 0, 92))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: blockVertical * 2,
                                left: blockHorizontal * 1,
                                right: blockHorizontal * 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                baris2(
                                    blockHorizontal,
                                    blockVertical,
                                    "Man Power",
                                    (e.state == 1) ? "Rp.${e.manpower},-" : "-",
                                    Color.fromARGB(255, 48, 207, 0)),
                                SizedBox(
                                  width: blockHorizontal * 1.5,
                                ),
                                baris2(
                                    blockHorizontal,
                                    blockVertical,
                                    "Tarif kWh",
                                    (e.state == 1)
                                        ? "Rp.${e.tarif_kwh},-"
                                        : "-",
                                    Color.fromARGB(255, 216, 0, 0)),
                                SizedBox(
                                  width: blockHorizontal * 1.5,
                                ),
                                baris2(
                                    blockHorizontal,
                                    blockVertical,
                                    "Unit Price (Rp)",
                                    (e.state == 1)
                                        ? "Rp.${e.harga_unit},-"
                                        : "-",
                                    Color.fromARGB(255, 0, 12, 187)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: blockVertical * 2,
                                left: blockHorizontal * 1,
                                right: blockHorizontal * 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                baris2(
                                    blockHorizontal,
                                    blockVertical,
                                    "Waktu",
                                    (e.state == 1)
                                        ? "${toDateTime(e.waktu.toInt())}"
                                        : "-",
                                    HexColor('6600CC')),
                                SizedBox(
                                  width: blockHorizontal * 1.5,
                                ),
                                baris2(
                                    blockHorizontal,
                                    blockVertical,
                                    "Daya (kW)",
                                    (e.state == 1)
                                        ? "${e.daya.toStringAsFixed(2)}"
                                        : "-",
                                    HexColor('#FF00FF')),
                                SizedBox(
                                  width: blockHorizontal * 1.5,
                                ),
                                baris2(
                                    blockHorizontal,
                                    blockVertical,
                                    "Good",
                                    (e.state == 1) ? "${e.good}" : "-",
                                    HexColor('#CCCC00')),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: blockHorizontal * 2),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey,
                        child: Container(
                          height: blockVertical * 22,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(blockVertical * 3)),
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Text("ERROR"),
                );
              },
            ),
            ////LIST RIWAYAT ----------------------------------------------------------------------------------------------------------------
            Container(
              margin: EdgeInsets.only(top: blockVertical * 3),
              height: blockVertical * 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(blockVertical * 2),
                  topRight: Radius.circular(blockVertical * 2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: blockVertical * 2,
                        left: blockVertical * 2,
                        bottom: blockVertical * 1),
                    child: Text(
                      "Recents Activity",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: blockVertical * 3,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: blockVertical * 45,
                    child: SingleChildScrollView(
                      child: StreamBuilder(
                          stream: streamCostH.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: listCostH.map((e) {
                                  if (e.good != 0) {
                                    return listHistory(
                                        context,
                                        "Good: ${e.good}",
                                        "${e.tanggal}",
                                        // "${e.tipe}",
                                        "Rp. ${e.total_harga.toStringAsFixed(2)},-",
                                        FontAwesomeIcons.dollarSign);
                                  }
                                  return Center();
                                }).toList(),
                              );
                            } else if (snapshot.connectionState ==
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
                            }
                            return Column(
                              children: [
                                Container(
                                  height: blockVertical * 30,
                                  width: double.infinity,
                                  color: Colors.white,
                                )
                              ],
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget baris1(double blockHorizontal, double blockVertical, String title,
      String isi, Color colors) {
    return Container(
      padding: EdgeInsets.all(blockVertical * 1),
      height: blockVertical * 10,
      width: blockHorizontal * 45,
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(blockVertical * 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: blockVertical * 1.8,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(
            isi,
            style: TextStyle(
                color: Colors.white,
                fontSize: blockVertical * 2.5,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget baris2(double blockHorizontal, double blockVertical, String title,
      String isi, Color colors) {
    return Container(
      padding: EdgeInsets.all(blockVertical * 1),
      height: blockVertical * 10,
      width: blockHorizontal * 28,
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(blockHorizontal * 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: blockVertical * 1.8,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(
            isi,
            style: TextStyle(
                color: Colors.white,
                fontSize: blockVertical * 2.5,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
