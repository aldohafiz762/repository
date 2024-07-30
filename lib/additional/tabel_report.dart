// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/additional/report_pdf.dart';
import 'package:project_tugas_akhir_copy/models/bigloss_model.dart';
import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:project_tugas_akhir_copy/services/bigloss_service.dart';
import 'package:project_tugas_akhir_copy/services/costprice_service.dart';
import 'package:project_tugas_akhir_copy/services/quality_service.dart';
// import 'package:project_tugas_akhir_copy/services/costprice_service.dart';
import 'package:project_tugas_akhir_copy/services/oee_service.dart';
// import 'package:project_tugas_akhir_copy/services/param_service.dart';

// import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';
// import 'package:project_tugas_akhir_copy/models/param_model.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../services/stock_service.dart';
import '../models/stock_model.dart';

//-------------------------------------------------ALL MACHINE---------------------------------------------------//
//---------------------------------------TABLE STOCK-----------------------------------------//
class TableStock extends StatefulWidget {
  const TableStock({super.key});

  @override
  State<TableStock> createState() => _TableStockState();
}

class _TableStockState extends State<TableStock> {
  StreamController streamStock = StreamController.broadcast();
  late Timer timer;
  List<StockModel> stockList = [];
  ReadStock getstockM1 = ReadStock();
  Future<void> stockData() async {
    stockList = await ReadStock.historyStock();
    streamStock.add(stockList);
  }

  @override
  void initState() {
    stockData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder(
        stream: streamStock.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> state) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
              borderRadius: BorderRadius.circular(blockVertical * 2),
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
              // DataColumn(
              //     label: Text(
              //   "Machine",
              //   style:
              //       TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              // )),
              DataColumn(
                  label: Text(
                "Latest Update",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Stock",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "StockIn",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "StockOut",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              // DataColumn(
              //     label: Text(
              //   "Type B",
              //   style:
              //       TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              // )),
              // DataColumn(
              //     label: Text(
              //   "Type C",
              //   style:
              //       TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              // )),
            ],
            rows: stockList.map((e) {
              DateTime localTime =
                  DateTime.parse(e.updatedAt.toString()).toLocal();
              String formattedUpdated =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);
              return DataRow(cells: [
                // DataCell(Text(
                //   "Machine ${e.machine_id}",
                //   style: TextStyle(fontSize: blockVertical * 2),
                // )),
                DataCell(Text(
                  formattedUpdated,
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${e.stock} Unit",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${e.stockIn} Unit",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${e.stockOut} Unit",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                // DataCell(Text(
                //   "${e.B} Unit",
                //   style: TextStyle(fontSize: blockVertical * 2),
                // )),
                // DataCell(Text(
                //   "${e.C} Unit ",
                //   style: TextStyle(fontSize: blockVertical * 2),
                // )),
              ]);
            }).toList(),
          );
        });
  }
}

//---------------------------------------TABLE PRODUCTION-----------------------------------------//
class TableProduction extends StatefulWidget {
  const TableProduction({super.key});

  @override
  State<TableProduction> createState() => _TableProductionState();
}

class _TableProductionState extends State<TableProduction> {
  //PRODUCTION
  StreamController<List<DashQuality>> streamProcessed =
      StreamController.broadcast();
  List<DashQuality> stockProcessed = [];
  HistoryQuality getStockprocessed = HistoryQuality();
  Future<void> processedData() async {
    stockProcessed = await HistoryQuality.historyQuality(1);
    streamProcessed.add(stockProcessed);
  }
  // StreamController<List<DashQuality>> streamProd = StreamController.broadcast();
  // List<DashQuality> qList = [];
  // QualityDash quality = QualityDash();
  // Future<void> qualityData() async {
  //   qList = await RecordQuality.get();
  //   streamProd.add(qList);
  // }

  @override
  void initState() {
    processedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder<List<DashQuality>>(
        stream: streamProcessed.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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

          return DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> state) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
              borderRadius: BorderRadius.circular(blockVertical * 2),
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
              // DataColumn(
              //     label: Text(
              //   "Machine",
              //   style:
              //       TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              // )),
              DataColumn(
                  label: Text(
                "Initially Created",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Latest Updated",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Processed",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Good Processed",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Defect Processed",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
            ],
            rows: stockProcessed.map((e) {
              DateTime localcreatedTime =
                  DateTime.parse(e.createdAt.toString()).toLocal();
              String formattedcreatedTime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(localcreatedTime);
              // .split(' ')[0];
              DateTime localupdateTime =
                  DateTime.parse(e.createdAt.toString()).toLocal();
              String formattedupdateTime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(localupdateTime);
              // .split(' ')[0];
              return DataRow(cells: [
                // DataCell(Text(
                //   "Machine ${e.machine_id}",
                //   style: TextStyle(fontSize: blockVertical * 2),
                // )),
                DataCell(Text(
                  formattedcreatedTime,
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  formattedupdateTime,
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.processed).toInt()} Unit",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.good).toInt()} Unit ",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.defect).toInt()} Unit ",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
              ]);
            }).toList(),
          );
        });
  }
}

//---------------------------------------TABLE OEE-----------------------------------------//
class TableOEE extends StatefulWidget {
  const TableOEE({super.key});

  @override
  State<TableOEE> createState() => _TableOEEState();
}

class _TableOEEState extends State<TableOEE> {
  //OEE
  StreamController<List<OEEdashModel>> streamOEEH =
      StreamController.broadcast();
  List<OEEdashModel> listOEEH = [];
  OEEHistori latestOEEH = OEEHistori();
  Future<void> oeeHData() async {
    listOEEH = await OEEHistori.historyOEE();
    streamOEEH.add(listOEEH);
  }

  @override
  void initState() {
    oeeHData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder(
        stream: streamOEEH.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> state) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
              borderRadius: BorderRadius.circular(blockVertical * 2),
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
                  label: Text(
                "Initially Created",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Latest Update",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Availability",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Performance",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Quality",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "OEE Result",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
            ],
            rows: listOEEH.map((e) {
              DateTime localUpdated =
                  DateTime.parse(e.updatedAt.toString()).toLocal();
              String formattedUpdated =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(localUpdated);
              DateTime localTime =
                  DateTime.parse(e.createdAt.toString()).toLocal();
              String formattedcreated =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);
              return DataRow(cells: [
                DataCell(Text(
                  formattedcreated,
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  formattedUpdated,
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.availability * 100).toStringAsFixed(2)} %",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.performance * 100).toStringAsFixed(2)} % ",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.quality * 100).toStringAsFixed(2)} % ",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.nilaioee * 100).toStringAsFixed(2)} % ",
                  style: TextStyle(
                      fontSize: blockVertical * 2,
                      color: (e.nilaioee * 100 >= 85)
                          ? Color.fromARGB(255, 8, 230, 15)
                          : Color.fromARGB(255, 243, 16, 0)),
                )),
              ]);
            }).toList(),
          );
        });
  }
}

//---------------------------------------TABLE OEE-----------------------------------------//
class TableBL extends StatefulWidget {
  const TableBL({super.key});

  @override
  State<TableBL> createState() => _TableBLState();
}

class _TableBLState extends State<TableBL> {
  //STREAM CONTROLLER BIGLOSSES
  StreamController<List<DashBLModel>> streamBL = StreamController.broadcast();
  List<DashBLModel> blList = [];
  HistoryBL bigloss = HistoryBL();
  Future<void> blData() async {
    blList = await HistoryBL.historyBL();
    streamBL.add(blList);
  }

  @override
  void initState() {
    blData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder(
        stream: streamBL.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> state) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
              borderRadius: BorderRadius.circular(blockVertical * 2),
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
                  label: Text(
                "Initially Created",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Latest Update",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Setup",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Breakdown",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Stoppage",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Speed",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Startup Reject",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Reject",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
            ],
            rows: blList.map((e) {
              // int index = blList.indexOf(e);
              // String Number = (index + 1)
              //     .toString()
              //     .padLeft(stockProcessed.length.toString().length);

              return DataRow(cells: [
                DataCell(Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.parse(e.createdAt.toString()).toLocal()),
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.parse(e.updatedAt.toString()).toLocal()),
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.setup / 60).toStringAsFixed(2)} Minutes",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.breakdown / 60).toStringAsFixed(2)} Minutes",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.stoppage / 60).toStringAsFixed(2)} Minutes",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.speed / 60).toStringAsFixed(2)} Minutes",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.startup).toInt()} Unit ",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "${(e.reject).toInt()} Unit ",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
              ]);
            }).toList(),
          );
        });
  }
}

class TableCost extends StatefulWidget {
  const TableCost({super.key});

  @override
  State<TableCost> createState() => _TableCostState();
}

class _TableCostState extends State<TableCost> {
  //STREAM CONTROLLER COST
  StreamController<List<GetCostHModel>> streamCost =
      StreamController.broadcast();
  List<GetCostHModel> costList = [];
  ReportCost cost = ReportCost();
  Future<void> costData() async {
    costList = await ReportCost.reportCost();
    streamCost.add(costList);
  }

  @override
  void initState() {
    costData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder(
        stream: streamCost.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> state) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
              borderRadius: BorderRadius.circular(blockVertical * 2),
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
                  label: Text(
                "Initially Create",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Latest Update",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Biaya Material",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Biaya Overhead",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "Biaya Manpower",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
              DataColumn(
                  label: Text(
                "HPP",
                style:
                    TextStyle(color: Colors.black, fontSize: blockVertical * 2),
              )),
            ],
            rows: costList.map((e) {
              // int index = blList.indexOf(e);
              // String Number = (index + 1)
              //     .toString()
              //     .padLeft(stockProcessed.length.toString().length);
              dynamic tarif_listrik = e.daya * e.tarif_kwh * (e.waktu / 3600);
              dynamic upah = e.manpower! * (e.waktu / 3600);
              int harga_total = e.good! * e.harga_unit!;
              dynamic harga_produksi = tarif_listrik + upah + harga_total;
              return DataRow(cells: [
                DataCell(Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.parse(e.createdAt.toString()).toLocal()),
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(DateTime.parse(e.updatedAt.toString()).toLocal()),
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "Rp.${(harga_total).toStringAsFixed(2)},-",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "Rp.${(tarif_listrik).toStringAsFixed(2)},-",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "Rp.${(upah).toStringAsFixed(2)},-",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
                DataCell(Text(
                  "Rp.${(harga_produksi).toStringAsFixed(2)},-",
                  style: TextStyle(fontSize: blockVertical * 2),
                )),
              ]);
            }).toList(),
          );
        });
  }
}

//---------------------------------------TABLE PARAMETER-----------------------------------------//
// class tableParameter extends StatefulWidget {
//   const tableParameter({super.key});

//   @override
//   State<tableParameter> createState() => _tableParameterState();
// }

// class _tableParameterState extends State<tableParameter> {
//   //Parameter
//   StreamController<List> streamParam = StreamController.broadcast();
//   List<paramReportModel> ParamList = [];
//   reportParam Param = reportParam();
//   Future<void> ParamData() async {
//     ParamList = await Param.getParam();
//     streamParam.add(ParamList);
//   }

//   @override
//   void initState() {
//     ParamData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryheight = MediaQuery.of(context).size.height;
//     double blockVertical = MediaQueryheight / 100;
//     return StreamBuilder(
//         stream: streamParam.stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.white,
//                 highlightColor: Colors.grey,
//                 child: Text(
//                   'Loading',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: blockVertical * 5,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }
//           return DataTable(
//             headingRowColor: MaterialStateProperty.resolveWith<Color?>(
//                 (Set<MaterialState> state) {
//               return Theme.of(context).colorScheme.primary.withOpacity(0.5);
//             }),
//             border: TableBorder(
//               top: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               left: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               right: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               bottom: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               borderRadius: BorderRadius.circular(blockVertical * 2),
//               verticalInside: BorderSide(
//                 width: blockVertical * 0.2,
//                 color: Colors.black.withOpacity(0.3),
//               ),
//               horizontalInside: BorderSide(
//                 width: 3,
//                 color: Colors.black.withOpacity(0.1),
//               ),
//             ),
//             columns: [
//               DataColumn(
//                   label: Text(
//                 "Machine",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Latest Update",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Type",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Loading Time",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Cycle Time",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "OEE Target",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//             ],
//             rows: ParamList.map((e) {
//               var date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                   .parse(e.updatedAt!)
//                   .toLocal()
//                   .toString()
//                   .split(' ')[0];
//               return DataRow(cells: [
//                 DataCell(Text(
//                   "Machine ${e.machine_id}",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   date,
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   "${e.tipe_benda}",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   "${e.loading_time} Menit ",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   "${e.cycle_time} Menit ",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text("${e.oee_target} % ",
//                     style: TextStyle(
//                       fontSize: blockVertical * 2,
//                     ))),
//               ]);
//             }).toList(),
//           );
//         });
//   }
// }

//---------------------------------------TABLE COST PRICE-----------------------------------------//
// class TableCost extends StatefulWidget {
//   const TableCost({super.key});

//   @override
//   State<TableCost> createState() => _TableCostState();
// }

// class _TableCostState extends State<TableCost> {
//   //Cost
//   StreamController<List> streamCost = StreamController.broadcast();
//   List<GetCostdashModel> costList = [];
//   GetDashCost cost = GetDashCost();
//   Future<void> costData() async {
//     costList = await cost.getCostDash();
//     streamCost.add(costList);
//   }

//   @override
//   void initState() {
//     costData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryheight = MediaQuery.of(context).size.height;
//     double blockVertical = MediaQueryheight / 100;
//     return StreamBuilder(
//         stream: streamCost.stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.white,
//                 highlightColor: Colors.grey,
//                 child: Text(
//                   'Loading',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: blockVertical * 5,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }
//           return DataTable(
//             headingRowColor: MaterialStateProperty.resolveWith<Color?>(
//                 (Set<MaterialState> state) {
//               return Theme.of(context).colorScheme.primary.withOpacity(0.5);
//             }),
//             border: TableBorder(
//               top: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               left: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               right: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               bottom: BorderSide(
//                   width: blockVertical * 0.2,
//                   color: Colors.black.withOpacity(0.3)),
//               borderRadius: BorderRadius.circular(blockVertical * 2),
//               verticalInside: BorderSide(
//                 width: blockVertical * 0.2,
//                 color: Colors.black.withOpacity(0.3),
//               ),
//               horizontalInside: BorderSide(
//                 width: 3,
//                 color: Colors.black.withOpacity(0.1),
//               ),
//             ),
//             columns: [
//               DataColumn(
//                   label: Text(
//                 "Machine",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Latest Update",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Type",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Good Processed",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Unit Price",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//               DataColumn(
//                   label: Text(
//                 "Total Price",
//                 style:
//                     TextStyle(color: Colors.black, fontSize: blockVertical * 2),
//               )),
//             ],
//             rows: costList.map((e) {
//               var date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                   .parse(e.updatedAt!)
//                   .toLocal()
//                   .toString()
//                   .split(' ')[0];
//               return DataRow(cells: [
//                 DataCell(Text(
//                   "Machine ${e.machine_id}",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   date,
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   "${e.tipe}",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   "${e.good} Unit",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text(
//                   "Rp.${e.harga_unit},-",
//                   style: TextStyle(fontSize: blockVertical * 2),
//                 )),
//                 DataCell(Text("Rp.${e.total_harga},-",
//                     style: TextStyle(
//                       fontSize: blockVertical * 2,
//                     ))),
//               ]);
//             }).toList(),
//           );
//         });
//   }
// }
//---------------------------------------------------ALL MACHINE END-----------------------------------------------//

//---------------------------------------------------SINGLE MACHINE-----------------------------------------------//
//---------------PRODUCTION--------------//
class ProductionPDF extends StatefulWidget {
  late int? mid;
  ProductionPDF({super.key, this.mid});

  @override
  State<ProductionPDF> createState() => _ProductionPDFState();
}

class _ProductionPDFState extends State<ProductionPDF> {
  int i = 1;
  StreamController<List> streamProcessed = StreamController.broadcast();
  List<RecQuality> stockProcessed = [];
  RecordQuality getStockprocessed = RecordQuality();
  Future<void> processedData() async {
    stockProcessed = await getStockprocessed.getrecQuality(widget.mid!);
    streamProcessed.add(stockProcessed);
  }

  @override
  void initState() {
    processedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder<Object>(
        stream: streamProcessed.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Production Machine ${widget.mid}",
                  style: TextStyle(
                      fontSize: blockVertical * 2.5,
                      fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DataTable(
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
                            borderRadius:
                                BorderRadius.circular(blockVertical * 2),
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
                                label: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Latest Update",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Type",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Processed",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Good Processed",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Defect Processed",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                          ],
                          rows: stockProcessed.map((e) {
                            int index = stockProcessed.indexOf(e);
                            String Number = (index + 1).toString().padLeft(
                                stockProcessed.length.toString().length);
                            var date =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .parse(e.createdAt!)
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                            return DataRow(cells: [
                              DataCell(Text(
                                Number,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                date,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.tipe}",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.processed} Unit",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.good} Unit ",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.defect} Unit ",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                            ]);
                          }).toList(),
                        )
                      ]),
                ),
              ],
            ),
          );
        });
  }
}

//--------------BIGLOSSES--------------//
class BiglossesPDF extends StatefulWidget {
  late int? mid;
  BiglossesPDF({super.key, this.mid});

  @override
  State<BiglossesPDF> createState() => _BiglossesPDFState();
}

class _BiglossesPDFState extends State<BiglossesPDF> {
  int i = 1;
  StreamController<List<DashBLModel>> streamBL = StreamController.broadcast();
  List<DashBLModel> blList = [];
  DashBL bigloss = DashBL();
  Future<void> blData() async {
    blList = await DashBL.dashBL();
    streamBL.add(blList);
  }

  @override
  void initState() {
    blData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder<Object>(
        stream: streamBL.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Production Machine ${widget.mid}",
                  style: TextStyle(
                      fontSize: blockVertical * 2.5,
                      fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DataTable(
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
                            borderRadius:
                                BorderRadius.circular(blockVertical * 2),
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
                                label: Text(
                              "Initially Created",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Latest Update",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Setup",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Breakdown",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Stoppage",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Speed",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Startup Reject",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Reject",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                          ],
                          rows: blList.map((e) {
                            int index = blList.indexOf(e);
                            String Number = (index + 1)
                                .toString()
                                .padLeft(qlist.length.toString().length);

                            return DataRow(cells: [
                              DataCell(Text(
                                Number,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    DateTime.parse(e.updatedAt.toString())
                                        .toLocal()),
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.setup}",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.breakdown} Unit",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.stoppage} Unit ",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.speed} Unit ",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.startup} Unit ",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.reject} Unit ",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                            ]);
                          }).toList(),
                        )
                      ]),
                ),
              ],
            ),
          );
        });
  }
}

//---------------STOCK--------------//
class StockPDF extends StatefulWidget {
  late int? mid;
  StockPDF({super.key, this.mid});

  @override
  State<StockPDF> createState() => _StockPDFState();
}

class _StockPDFState extends State<StockPDF> {
  int i = 1;
  StreamController<List> streamRiwayatStock = StreamController.broadcast();
  List<Historimodel> riwayatStockList = [];
  Getriwayat getriwayatstockM1 = Getriwayat();
  Future<void> riwayatstockData() async {
    riwayatStockList = await getriwayatstockM1.gethistori(widget.mid!);
    streamRiwayatStock.add(riwayatStockList);
  }

  @override
  void initState() {
    riwayatstockData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder<Object>(
        stream: streamRiwayatStock.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "History Stock In Machine ${widget.mid}",
                  style: TextStyle(
                      fontSize: blockVertical * 2.5,
                      fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DataTable(
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
                            borderRadius:
                                BorderRadius.circular(blockVertical * 2),
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
                                label: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Latest Update",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Type",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Stock In",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                          ],
                          rows: riwayatStockList.map((e) {
                            int index = riwayatStockList.indexOf(e);
                            String Number = (index + 1).toString().padLeft(
                                riwayatStockList.length.toString().length);
                            var date =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .parse(e.createdAt!)
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
                            return DataRow(cells: [
                              DataCell(Text(
                                Number,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                date,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.tipe}",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${e.jumlah} Unit",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                            ]);
                          }).toList(),
                        )
                      ]),
                ),
              ],
            ),
          );
        });
  }
}

//---------------COST PRICE--------------//
// class CostPDF extends StatefulWidget {
//   late int? mid;
//   CostPDF({super.key, this.mid});

//   @override
//   State<CostPDF> createState() => _CostPDFState();
// }

// class _CostPDFState extends State<CostPDF> {
//   int i = 1;
//   StreamController streamCostH = StreamController.broadcast();
//   List<GetCostHModel> listCostH = [];
//   GetCostHistori latestCostH = GetCostHistori();
//   Future<void> costHData() async {
//     listCostH = await latestCostH.getCostH(widget.mid!);
//     streamCostH.add(listCostH);
//   }

//   @override
//   void initState() {
//     costHData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryheight = MediaQuery.of(context).size.height;
//     double blockVertical = MediaQueryheight / 100;
//     return StreamBuilder(
//         stream: streamCostH.stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.white,
//                 highlightColor: Colors.grey,
//                 child: Text(
//                   'Loading',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: blockVertical * 5,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }
//           return SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "History Cost Price Machine ${widget.mid}",
//                   style: TextStyle(
//                       fontSize: blockVertical * 2.5,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         DataTable(
//                           headingRowColor:
//                               MaterialStateProperty.resolveWith<Color?>(
//                                   (Set<MaterialState> state) {
//                             return Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.5);
//                           }),
//                           border: TableBorder(
//                             top: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             left: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             right: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             bottom: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             borderRadius:
//                                 BorderRadius.circular(blockVertical * 2),
//                             verticalInside: BorderSide(
//                               width: blockVertical * 0.2,
//                               color: Colors.black.withOpacity(0.3),
//                             ),
//                             horizontalInside: BorderSide(
//                               width: 3,
//                               color: Colors.black.withOpacity(0.1),
//                             ),
//                           ),
//                           columns: [
//                             DataColumn(
//                                 label: Text(
//                               "No",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Latest Update",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Type",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Good Processed",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Unit Price (Rp)",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Total Price (Rp)",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                           ],
//                           rows: listCostH.map((e) {
//                             int index = listCostH.indexOf(e);
//                             String Number = (index + 1)
//                                 .toString()
//                                 .padLeft(listCostH.length.toString().length);
//                             var date =
//                                 DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                                     .parse(e.updatedAt!)
//                                     .toLocal()
//                                     .toString()
//                                     .split(' ')[0];

//                             return DataRow(cells: [
//                               DataCell(Text(
//                                 Number,
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 date,
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.tipe}",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.good} Unit",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.harga_unit},-",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.total_harga},-",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                             ]);
//                           }).toList(),
//                         )
//                       ]),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }

//---------------PARAMETER--------------//
// class ParameterPDF extends StatefulWidget {
//   late int? mid;
//   ParameterPDF({super.key, this.mid});

//   @override
//   State<ParameterPDF> createState() => _ParameterPDFState();
// }

// class _ParameterPDFState extends State<ParameterPDF> {
//   int i = 1;
//   StreamController streamParamH = StreamController.broadcast();
//   List<ParamReportModel> listParamH = [];
//   HistoriParam latestParamH = HistoriParam();
//   Future<void> ParamHData() async {
//     listParamH = await latestParamH.getParam(widget.mid!);
//     streamParamH.add(listParamH);
//   }

//   @override
//   void initState() {
//     ParamHData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final MediaQueryheight = MediaQuery.of(context).size.height;
//     double blockVertical = MediaQueryheight / 100;
//     return StreamBuilder(
//         stream: streamParamH.stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.white,
//                 highlightColor: Colors.grey,
//                 child: Text(
//                   'Loading',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: blockVertical * 5,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }
//           return SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "History Parameter Machine ${widget.mid}",
//                   style: TextStyle(
//                       fontSize: blockVertical * 2.5,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         DataTable(
//                           headingRowColor:
//                               MaterialStateProperty.resolveWith<Color?>(
//                                   (Set<MaterialState> state) {
//                             return Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.5);
//                           }),
//                           border: TableBorder(
//                             top: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             left: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             right: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             bottom: BorderSide(
//                                 width: blockVertical * 0.2,
//                                 color: Colors.black.withOpacity(0.3)),
//                             borderRadius:
//                                 BorderRadius.circular(blockVertical * 2),
//                             verticalInside: BorderSide(
//                               width: blockVertical * 0.2,
//                               color: Colors.black.withOpacity(0.3),
//                             ),
//                             horizontalInside: BorderSide(
//                               width: 3,
//                               color: Colors.black.withOpacity(0.1),
//                             ),
//                           ),
//                           columns: [
//                             DataColumn(
//                                 label: Text(
//                               "No",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Latest Update",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Type",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Loading Time (Minute)",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "Cycle Time (Minute)",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                             DataColumn(
//                                 label: Text(
//                               "OEE Target (%)",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: blockVertical * 2),
//                             )),
//                           ],
//                           rows: listParamH.map((e) {
//                             int index = listParamH.indexOf(e);
//                             String Number = (index + 1)
//                                 .toString()
//                                 .padLeft(listParamH.length.toString().length);
//                             var date =
//                                 DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                                     .parse(e.updatedAt!)
//                                     .toLocal()
//                                     .toString()
//                                     .split(' ')[0];

//                             return DataRow(cells: [
//                               DataCell(Text(
//                                 "${i++}",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 date,
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.tipe_benda}",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.loading_time}",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.cycle_time}",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                               DataCell(Text(
//                                 "${e.oee_target}",
//                                 style: TextStyle(fontSize: blockVertical * 2),
//                               )),
//                             ]);
//                           }).toList(),
//                         )
//                       ]),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }

//---------------OEE--------------//
class OEEPDF extends StatefulWidget {
  late int? mid;
  OEEPDF({super.key, this.mid});

  @override
  State<OEEPDF> createState() => _OEEPDFState();
}

class _OEEPDFState extends State<OEEPDF> {
  int i = 1;
  StreamController<List<OEEdashModel>> streamOEEH =
      StreamController.broadcast();
  List<OEEdashModel> listOEEH = [];
  OEEHistori latestOEEH = OEEHistori();
  Future<void> oeeHData() async {
    listOEEH = await OEEHistori.historyOEE();
    streamOEEH.add(listOEEH);
  }

  @override
  void initState() {
    oeeHData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryheight = MediaQuery.of(context).size.height;
    double blockVertical = MediaQueryheight / 100;
    return StreamBuilder(
        stream: streamOEEH.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "History Parameter Machine ${widget.mid}",
                  style: TextStyle(
                      fontSize: blockVertical * 2.5,
                      fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DataTable(
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
                            borderRadius:
                                BorderRadius.circular(blockVertical * 2),
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
                                label: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Latest Update",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Availability (%)",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Performance (%)",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "Quality (%)",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                            DataColumn(
                                label: Text(
                              "OEE Result (%)",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: blockVertical * 2),
                            )),
                          ],
                          rows: listOEEH.map((e) {
                            int index = listOEEH.indexOf(e);
                            String Number = (index + 1)
                                .toString()
                                .padLeft(listOEEH.length.toString().length);
                            var date =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .parse(e.updatedAt!)
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];

                            return DataRow(cells: [
                              DataCell(Text(
                                Number,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                date,
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${(e.availability * 100).toStringAsFixed(2)}",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${(e.performance * 100).toStringAsFixed(2)}",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${(e.quality * 100).toStringAsFixed(2)}",
                                style: TextStyle(fontSize: blockVertical * 2),
                              )),
                              DataCell(Text(
                                "${(e.nilaioee * 100).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: blockVertical * 2,
                                    color: (e.nilaioee * 100 >= 85)
                                        ? Color.fromARGB(255, 8, 230, 15)
                                        : Color.fromARGB(255, 243, 16, 0)),
                              )),
                            ]);
                          }).toList(),
                        )
                      ]),
                ),
              ],
            ),
          );
        });
  }
}
//---------------------------------------------------SINGLE MACHINE END-----------------------------------------------//