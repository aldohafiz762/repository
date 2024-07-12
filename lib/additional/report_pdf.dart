import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:project_tugas_akhir_copy/models/bigloss_model.dart';
import 'package:project_tugas_akhir_copy/services/bigloss_service.dart';
import 'package:project_tugas_akhir_copy/services/costprice_service.dart';
import 'package:project_tugas_akhir_copy/services/oee_service.dart';
// import 'package:project_tugas_akhir_copy/services/param_service.dart';
import 'package:project_tugas_akhir_copy/services/quality_service.dart';
import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';
// import 'package:project_tugas_akhir_copy/models/param_model.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:project_tugas_akhir_copy/services/stock_service.dart';
import 'package:project_tugas_akhir_copy/models/stock_model.dart';

//STOCK ALL
StreamController<List> streamStock = StreamController.broadcast();
List<StockModel> stockList = [];
ReadStock getstockM1 = ReadStock();
Future<void> stockData() async {
  stockList = await ReadStock.historyStock();
  streamStock.add(stockList);
}

//PRODUCTION ALL
StreamController<List<DashQuality>> streamProcessed =
    StreamController.broadcast();
List<DashQuality> qlist = [];
HistoryQuality getStockprocessed = HistoryQuality();
Future<void> processedData() async {
  qlist = await HistoryQuality.historyQuality(1);
  streamProcessed.add(qlist);
}

//OEE ALL
StreamController<List<OEEdashModel>> streamOEEH = StreamController.broadcast();
List<OEEdashModel> listOEEH = [];
OEEHistori latestOEEH = OEEHistori();
Future<void> oeeHData() async {
  listOEEH = await OEEHistori.historyOEE();
  streamOEEH.add(listOEEH);
}

StreamController<List<DashBLModel>> streamBL = StreamController.broadcast();
List<DashBLModel> blList = [];
DashBL bigloss = DashBL();
Future<void> blData() async {
  blList = await HistoryBL.historyBL();
  streamBL.add(blList);
}

//RIWAYAT STOCK IN
StreamController<List> streamRiwayatStock = StreamController.broadcast();
List<Historimodel> riwayatStockList = [];
Getriwayat getriwayatstockM1 = Getriwayat();
Future<void> riwayatstockData() async {
  riwayatStockList = await getriwayatstockM1.gethistori(1);
  streamRiwayatStock.add(riwayatStockList);
}

//RIWAYAT STOCK OUT
// StreamController<List> streamProcessed = StreamController.broadcast();
// List<RecQuality> stockProcessed = [];
// RecordQuality getStockprocessed = RecordQuality();
// Future<void> processedData() async {
//   stockProcessed = await getStockprocessed.getrecQuality(1);
//   streamProcessed.add(stockProcessed);
// }

//----------------------------------ALL MACHINE & ALL REPORT---------------------------------------//
Future<void> allmachinePDF() async {
  await stockData();
  await processedData();
  await oeeHData();
  await blData();

  final pdf = pw.Document();

  // Load custom fonts
  final fontDataRegular = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  final fontRegular = pw.Font.ttf(fontDataRegular);

  final fontDataBold = await rootBundle.load("fonts/NotoSans-Bold.ttf");
  final fontBold = pw.Font.ttf(fontDataBold);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Text(
              "PRODUCTION MONITORING SYSTEM REPORT",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "PRESS MACHINE",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "PRODUCTION",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
              headerStyle: pw.TextStyle(font: fontBold, fontSize: 12),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'Initially Created',
                'Latest Update',
                'Processed (unit)',
                'Good (unit)',
                'Defect (unit)',
              ],
              data: qlist
                  .map((e) => [
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.updatedAt.toString()).toLocal()),
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.updatedAt.toString()).toLocal()),
                        "${(e.processed).toInt()}",
                        "${(e.good).toInt()}",
                        "${(e.defect).toInt()}",
                      ])
                  .toList()),
          pw.SizedBox(height: 10),
          pw.Text(
            "OVERALL EQUIPMENT EFFECTIVENESS",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
              headerStyle: pw.TextStyle(font: fontBold, fontSize: 12),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'Initially Created',
                'Latest Update',
                'Availability (%)',
                'Performance (%)',
                'Quality (%)',
                'OEE Result (%)'
              ],
              data: listOEEH
                  .map((e) => [
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.createdAt.toString()).toLocal()),
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.updatedAt.toString()).toLocal()),
                        "${(e.availability * 100).toStringAsFixed(2)}",
                        "${(e.performance * 100).toStringAsFixed(2)}",
                        "${(e.quality * 100).toStringAsFixed(2)}",
                        "${(e.nilaioee * 100).toStringAsFixed(2)}",
                      ])
                  .toList()),
          pw.SizedBox(height: 10),
          pw.SizedBox(height: 10),
          pw.Text(
            "STOCK",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
              headerStyle: pw.TextStyle(font: fontBold, fontSize: 12),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: ['Latest Update', 'Stock', 'StockIn', 'StockOut'],
              data: stockList
                  .map((e) => [
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.updatedAt.toString()).toLocal()),
                        "${e.stock}",
                        "${e.stockIn}",
                        "${e.stockOut}",
                      ])
                  .toList()),
          pw.SizedBox(height: 70),
          pw.Text(
            "SIX BIG LOSSES",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
              headerStyle: pw.TextStyle(font: fontBold, fontSize: 12),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'Initially Created',
                'Latest Update',
                'Setup',
                'Breakdown',
                'Stoppage',
                'Speedloss',
                'Startup Reject',
                'Reject'
              ],
              data: blList
                  .map((e) => [
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.createdAt.toString()).toLocal()),
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            DateTime.parse(e.updatedAt.toString()).toLocal()),
                        "${(e.setup / 60).toStringAsFixed(2)} Minutes",
                        "${(e.breakdown / 60).toStringAsFixed(2)} Minutes",
                        "${(e.stoppage / 60).toStringAsFixed(2)} Minutes",
                        "${(e.speed / 60).toStringAsFixed(2)} Minutes",
                        "${(e.startup).toInt()} Unit ",
                        "${(e.reject).toInt()} Unit "
                      ])
                  .toList()),
        ];
      },
    ),
  ); // Page

  // Save PDF
  Uint8List bytes = await pdf.save();

  // Get external storage directory
  Directory? downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    throw FileSystemException("Could not get external storage directory");
  }

  // Create a directory within the external storage directory
  String dirPath = '${downloadsDir.path}/ProductionMonitoringReports';
  Directory directory = Directory(dirPath);
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  // Write PDF to a file within the created directory
  String filePath = '$dirPath/Production Monitoring Report.pdf';
  File file = File(filePath);
  await file.writeAsBytes(bytes);

  // Log path for debugging
  print('PDF saved at: $filePath');

  // Open PDF
  final result = await OpenFile.open(filePath);
  print(result);
} //----------------------------------ALL MACHINE & ALL REPORT END---------------------------------------//

//----------------------------------BIGLOSSES---------------------------------------//

Future<void> AMBL() async {
  await blData();
  final pdf = pw.Document();
// Load custom fonts
  final fontDataRegular = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  final fontRegular = pw.Font.ttf(fontDataRegular);

  final fontDataBold = await rootBundle.load("fonts/NotoSans-Bold.ttf");
  final fontBold = pw.Font.ttf(fontDataBold);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Text(
              "SIX BIGLOSSES REPORT",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "PRESS MACHINE",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "PRODUCTION",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
            cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
            headerStyle: pw.TextStyle(fontSize: 12, font: fontBold),
            headerAlignment: pw.Alignment.center,
            cellAlignment: pw.Alignment.center,
            headers: [
              'Initially Created',
              'Latest Update',
              'Setup (Min)',
              'Breakdown (Min)',
              'Stoppage (Min)',
              'Speedloss (Min)',
              'Startup Reject (Unit)',
              'Reject (Unit)'
            ],
            data: blList
                .map(
                  (e) => [
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.createdAt.toString()).toLocal()),
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.updatedAt.toString()).toLocal()),
                    // "${e.tipe}",
                    "${(e.setup / 60).toStringAsFixed(2)}",
                    "${(e.breakdown / 60).toStringAsFixed(2)}",
                    "${(e.stoppage / 60).toStringAsFixed(2)}",

                    "${(e.speed / 60).toStringAsFixed(2)}",
                    "${(e.startup).toInt()}",
                    "${(e.reject).toInt()}"
                  ],
                )
                .toList(),
          ),
        ];
      },
    ),
  ); // Page
  // Save PDF
  Uint8List bytes = await pdf.save();

  // Get external storage directory
  Directory? downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    throw FileSystemException("Could not get external storage directory");
  }

  // Create a directory within the external storage directory
  String dirPath = '${downloadsDir.path}/ProductionMonitoringReports';
  Directory directory = Directory(dirPath);
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  // Write PDF to a file within the created directory
  String filePath = '$dirPath/Production Monitoring Report.pdf';
  File file = File(filePath);
  await file.writeAsBytes(bytes);

  // Log path for debugging
  print('PDF saved at: $filePath');

  // Open PDF
  final result = await OpenFile.open(filePath);
  print(result);
}

//---------------------------------------------REPORT PRODUCTION----------------------------------------------------//
Future<void> AMRP() async {
  await processedData();
  final pdf = pw.Document();
// Load custom fonts
  final fontDataRegular = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  final fontRegular = pw.Font.ttf(fontDataRegular);

  final fontDataBold = await rootBundle.load("fonts/NotoSans-Bold.ttf");
  final fontBold = pw.Font.ttf(fontDataBold);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Text(
              "PRODUCTION REPORT",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "PRESS MACHINE",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "PRODUCTION",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
            cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
            headerStyle: pw.TextStyle(fontSize: 12, font: fontBold),
            headerAlignment: pw.Alignment.center,
            cellAlignment: pw.Alignment.center,
            headers: [
              'Initially Created',
              'Latest Update',
              'Processed (unit)',
              'Good (unit)',
              'Defect (unit)',
            ],
            data: qlist
                .map(
                  (e) => [
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.createdAt.toString()).toLocal()),
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.updatedAt.toString()).toLocal()),
                    // "${e.tipe}",
                    "${e.processed}",
                    "${e.good}",
                    "${e.defect}",
                  ],
                )
                .toList(),
          ),
        ];
      },
    ),
  ); // Page
  // Save PDF
  Uint8List bytes = await pdf.save();

  // Get external storage directory
  Directory? downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    throw FileSystemException("Could not get external storage directory");
  }

  // Create a directory within the external storage directory
  String dirPath = '${downloadsDir.path}/ProductionMonitoringReports';
  Directory directory = Directory(dirPath);
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  // Write PDF to a file within the created directory
  String filePath = '$dirPath/Production Monitoring Report.pdf';
  File file = File(filePath);
  await file.writeAsBytes(bytes);

  // Log path for debugging
  print('PDF saved at: $filePath');

  // Open PDF
  final result = await OpenFile.open(filePath);
  print(result);
}

//----------------------------------ALL MACHINE REPORT OEE---------------------------------------//

Future<void> AMROEE() async {
  await oeeHData();
  final pdf = pw.Document();
// Load custom fonts
  final fontDataRegular = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  final fontRegular = pw.Font.ttf(fontDataRegular);

  final fontDataBold = await rootBundle.load("fonts/NotoSans-Bold.ttf");
  final fontBold = pw.Font.ttf(fontDataBold);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Text(
              "OEE REPORT",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "PRESS MACHINE",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "OVERALL EQUIPMENT EFFECTIVENESS",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
            cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
            headerStyle: pw.TextStyle(fontSize: 12, font: fontBold),
            headerAlignment: pw.Alignment.center,
            cellAlignment: pw.Alignment.center,
            headers: [
              'Initially Created',
              'Latest Update',
              'Availability (%)',
              'Performance (%)',
              'Quality (%)',
              'OEE Result (%)'
            ],
            data: listOEEH
                .map(
                  (e) => [
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.createdAt.toString()).toLocal()),
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.updatedAt.toString()).toLocal()),
                    "${(e.availability * 100).toStringAsFixed(2)}",
                    "${(e.performance * 100).toStringAsFixed(2)}",
                    "${(e.quality * 100).toStringAsFixed(2)}",
                    "${(e.nilaioee * 100).toStringAsFixed(2)}",
                  ],
                )
                .toList(),
          ),
        ];
      },
    ),
  ); // Page
  // Save PDF
  Uint8List bytes = await pdf.save();

  // Get external storage directory
  Directory? downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    throw FileSystemException("Could not get external storage directory");
  }

  // Create a directory within the external storage directory
  String dirPath = '${downloadsDir.path}/ProductionMonitoringReports';
  Directory directory = Directory(dirPath);
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  // Write PDF to a file within the created directory
  String filePath = '$dirPath/Production Monitoring Report.pdf';
  File file = File(filePath);
  await file.writeAsBytes(bytes);

  // Log path for debugging
  print('PDF saved at: $filePath');

  // Open PDF
  final result = await OpenFile.open(filePath);
  print(result);
}

//----------------------------------ALL MACHINE REPORT PARAMETER---------------------------------------//

// Future<void> AMRPARAM() async {
//   await ParamData();
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return [
//           pw.Center(
//             child: pw.Text(
//               "PARAMETER REPORT",
//               softWrap: true,
//               style:
//                   pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
//             ),
//           ),
//           pw.Center(
//             child: pw.Text(
//               "4 MACHINE",
//               softWrap: true,
//               style:
//                   pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
//             ),
//           ),
//           pw.SizedBox(height: 20),
//           pw.Text(
//             "PARAMETER",
//             softWrap: true,
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.Table.fromTextArray(
//             cellStyle: pw.TextStyle(fontSize: 12),
//             headerStyle:
//                 pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//             headerAlignment: pw.Alignment.center,
//             cellAlignment: pw.Alignment.center,
//             headers: [
//               'Machine',
//               'Latest Update',
//               'Type',
//               'Loading Time (menit)',
//               'Cycle Time (menit)',
//               'OEE Target (%)',
//             ],
//             data: ParamList.map(
//               (e) => [
//                 "${e.machine_id}",
//                 (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                     .parse(e.updatedAt!)
//                     .toLocal()
//                     .toString()
//                     .split(' ')[0]),
//                 "${e.tipe_benda}",
//                 "${e.loading_time}",
//                 "${e.cycle_time}",
//                 "${e.oee_target}",
//               ],
//             ).toList(),
//           ),
//         ];
//       },
//     ),
//   ); // Page
//   // SIMPAN
//   Uint8List bytes = await pdf.save();

//   // buat file kosong di directory
//   final dir = await getApplicationDocumentsDirectory();
//   final file = File('${dir.path}/Parameter Report.pdf');

//   // timpa file kosong dengan file pdf
//   await file.writeAsBytes(bytes);

//   //open pdf
//   await OpenFile.open(file.path);
// }

//----------------------------------ALL MACHINE REPORT STOCK---------------------------------------//

Future<void> AMRS() async {
  await stockData();
  final pdf = pw.Document();
// Load custom fonts
  final fontDataRegular = await rootBundle.load("fonts/NotoSans-Regular.ttf");
  final fontRegular = pw.Font.ttf(fontDataRegular);

  final fontDataBold = await rootBundle.load("fonts/NotoSans-Bold.ttf");
  final fontBold = pw.Font.ttf(fontDataBold);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Text(
              "STOCK REPORT",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "PRESS MACHINE",
              softWrap: true,
              style: pw.TextStyle(font: fontBold, fontSize: 16),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "STOCK",
            softWrap: true,
            style: pw.TextStyle(
              font: fontBold,
            ),
          ),
          pw.Table.fromTextArray(
            cellStyle: pw.TextStyle(font: fontRegular, fontSize: 12),
            headerStyle: pw.TextStyle(fontSize: 12, font: fontBold),
            headerAlignment: pw.Alignment.center,
            cellAlignment: pw.Alignment.center,
            headers: [
              // 'Initially Created',
              'Latest Update',
              'Stock',
              'StockIn',
              'StockOut'
            ],
            data: stockList
                .map(
                  (e) => [
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                        DateTime.parse(e.updatedAt.toString()).toLocal()),
                    "${e.stock}",
                    "${e.stockIn}",
                    "${e.stockOut}"
                    // "${e.B}",
                    // "${e.C}"
                  ],
                )
                .toList(),
          ),
        ];
      },
    ),
  ); // Page
  // Save PDF
  Uint8List bytes = await pdf.save();

  // Get external storage directory
  Directory? downloadsDir = await getExternalStorageDirectory();
  if (downloadsDir == null) {
    throw FileSystemException("Could not get external storage directory");
  }

  // Create a directory within the external storage directory
  String dirPath = '${downloadsDir.path}/ProductionMonitoringReports';
  Directory directory = Directory(dirPath);
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  // Write PDF to a file within the created directory
  String filePath = '$dirPath/Production Monitoring Report.pdf';
  File file = File(filePath);
  await file.writeAsBytes(bytes);

  // Log path for debugging
  print('PDF saved at: $filePath');

  // Open PDF
  final result = await OpenFile.open(filePath);
  print(result);
}

//----------------------------------ALL MACHINE REPORT COST PRICE---------------------------------------//

// Future<void> AMRCS() async {
//   await costData();
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return [
//           pw.Center(
//             child: pw.Text(
//               "COST PRICE REPORT",
//               softWrap: true,
//               style:
//                   pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
//             ),
//           ),
//           pw.Center(
//             child: pw.Text(
//               "4 MACHINE",
//               softWrap: true,
//               style:
//                   pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
//             ),
//           ),
//           pw.SizedBox(height: 20),
//           pw.Text(
//             "COST PRICE",
//             softWrap: true,
//             style: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.Table.fromTextArray(
//             cellStyle: pw.TextStyle(fontSize: 12),
//             headerStyle:
//                 pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//             headerAlignment: pw.Alignment.center,
//             cellAlignment: pw.Alignment.center,
//             headers: [
//               'Machine',
//               'Latest Update',
//               'Type',
//               'Good Processed',
//               'Unit Price',
//               'Total Price',
//             ],
//             data: costList
//                 .map(
//                   (e) => [
//                     "${e.machine_id}",
//                     (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                         .parse(e.updatedAt!)
//                         .toLocal()
//                         .toString()
//                         .split(' ')[0]),
//                     "${e.tipe}",
//                     "${e.good}",
//                     "${e.harga_unit}",
//                     "${e.total_harga}"
//                   ],
//                 )
//                 .toList(),
//           ),
//         ];
//       },
//     ),
//   ); // Page
//   // SIMPAN
//   Uint8List bytes = await pdf.save();

//   // buat file kosong di directory
//   final dir = await getApplicationDocumentsDirectory();
//   final file = File('${dir.path}/Cost Price Report.pdf');

//   // timpa file kosong dengan file pdf
//   await file.writeAsBytes(bytes);

//   //open pdf
//   await OpenFile.open(file.path);
// }
