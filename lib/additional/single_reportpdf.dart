import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:project_tugas_akhir_copy/services/costprice_service.dart';
import 'package:project_tugas_akhir_copy/services/oee_service.dart';
// import 'package:project_tugas_akhir_copy/services/param_service.dart';
import 'package:project_tugas_akhir_copy/services/quality_service.dart';
import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';
// import 'package:project_tugas_akhir_copy/models/param_model.dart';
import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_tugas_akhir_copy/services/stock_service.dart';
import 'package:project_tugas_akhir_copy/models/stock_model.dart';

//--------------------------------------PRODUCTION-------------------------------------------//
class ProductionMPDF {
  late int? mid;

  ProductionMPDF({this.mid});
  int i = 1;
  StreamController<List> streamProcessed = StreamController.broadcast();
  List<RecQuality> stockProcessed = [];
  RecordQuality getStockprocessed = RecordQuality();
  Future<void> processedData() async {
    stockProcessed = await getStockprocessed.getrecQuality(mid!);
    streamProcessed.add(stockProcessed);
  }

  Future<void> AMRP() async {
    await processedData();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "PRODUCTION REPORT",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.Center(
              child: pw.Text(
                "MACHINE $mid",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "PRODUCTION",
              softWrap: true,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(fontSize: 12),
              headerStyle:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'No',
                'Latest Update',
                'Type',
                'Processed (unit)',
                'Good (unit)',
                'Defect (unit)',
              ],
              data: stockProcessed
                  .map(
                    (e) => [
                      "${i++}",
                      (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .parse(e.createdAt!)
                          .toLocal()
                          .toString()
                          .split(' ')[0]),
                      "${e.tipe}",
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
    // SIMPAN
    Uint8List bytes = await pdf.save();

    // buat file kosong di directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Production Report Machine $mid.pdf');

    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }
}

//--------------------------------------OEE-------------------------------------------//
class OEEMPDF {
  late int? mid;

  OEEMPDF({this.mid});

  int i = 1;
  StreamController streamOEEH = StreamController.broadcast();
  List<OEEHistoriModel> listOEEH = [];
  OEEHistori latestOEEH = OEEHistori();
  Future<void> OEEHData() async {
    listOEEH = await latestOEEH.historyOEE(mid!);
    streamOEEH.add(listOEEH);
  }

  Future<void> AMROEE() async {
    await OEEHData();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "OEE REPORT",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.Center(
              child: pw.Text(
                "MACHINE $mid",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "OVERALL EQUIPMENT EFFECTIVENESS",
              softWrap: true,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(fontSize: 12),
              headerStyle:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'No',
                'Latest Update',
                'Availability (%)',
                'Performance (%)',
                'Quality (%)',
                'OEE Result (%)'
              ],
              data: listOEEH
                  .map(
                    (e) => [
                      "${i++}",
                      (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .parse(e.updatedAt!)
                          .toLocal()
                          .toString()
                          .split(' ')[0]),
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
    // SIMPAN
    Uint8List bytes = await pdf.save();

    // buat file kosong di directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/OEE Report Machine $mid.pdf');

    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }
}

//--------------------------------------STOCK-------------------------------------------//
class StockMPDF {
  late int? mid;

  StockMPDF({this.mid});

  int i = 1;
  StreamController<List> streamRiwayatStock = StreamController.broadcast();
  List<Historimodel> riwayatStockList = [];
  Getriwayat getriwayatstockM1 = Getriwayat();
  Future<void> riwayatstockData() async {
    riwayatStockList = await getriwayatstockM1.gethistori(mid!);
    streamRiwayatStock.add(riwayatStockList);
  }

  Future<void> AMRS() async {
    await riwayatstockData();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "STOCK REPORT",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.Center(
              child: pw.Text(
                "MACHINE $mid",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "STOCK",
              softWrap: true,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(fontSize: 12),
              headerStyle:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'Machine',
                'Latest Update',
                'Type',
                'Stock In',
              ],
              data: riwayatStockList
                  .map(
                    (e) => [
                      "${i++}",
                      (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .parse(e.createdAt!)
                          .toLocal()
                          .toString()
                          .split(' ')[0]),
                      "${e.tipe}",
                      "${e.jumlah}",
                    ],
                  )
                  .toList(),
            ),
          ];
        },
      ),
    ); // Page
    // SIMPAN
    Uint8List bytes = await pdf.save();

    // buat file kosong di directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Stock Report Machine $mid.pdf');

    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }
}

//--------------------------------------PARAMETER-------------------------------------------//
// class ParameterMPDF {
//   late int? mid;

//   ParameterMPDF({this.mid});

//   int i = 1;
//   StreamController streamParamH = StreamController.broadcast();
//   List<paramReportModel> listParamH = [];
//   HistoriParam latestParamH = HistoriParam();
//   Future<void> ParamHData() async {
//     listParamH = await latestParamH.getParam(mid!);
//     streamParamH.add(listParamH);
//   }

//   Future<void> AMRPARAM() async {
//     await ParamHData();
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return [
//             pw.Center(
//               child: pw.Text(
//                 "PARAMETER REPORT",
//                 softWrap: true,
//                 style:
//                     pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
//               ),
//             ),
//             pw.Center(
//               child: pw.Text(
//                 "MACHINE $mid",
//                 softWrap: true,
//                 style:
//                     pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
//               ),
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text(
//               "PARAMETER",
//               softWrap: true,
//               style: pw.TextStyle(
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//             pw.Table.fromTextArray(
//               cellStyle: pw.TextStyle(fontSize: 12),
//               headerStyle:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//               headerAlignment: pw.Alignment.center,
//               cellAlignment: pw.Alignment.center,
//               headers: [
//                 'No',
//                 'Latest Update',
//                 'Type',
//                 'Loading Time (menit)',
//                 'Cycle Time (menit)',
//                 'OEE Target (%)',
//               ],
//               data: listParamH
//                   .map(
//                     (e) => [
//                       "${i++}",
//                       (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                           .parse(e.updatedAt!)
//                           .toLocal()
//                           .toString()
//                           .split(' ')[0]),
//                       "${e.tipe_benda}",
//                       "${e.loading_time}",
//                       "${e.cycle_time}",
//                       "${e.oee_target}",
//                     ],
//                   )
//                   .toList(),
//             ),
//           ];
//         },
//       ),
//     ); // Page
//     // SIMPAN
//     Uint8List bytes = await pdf.save();

//     // buat file kosong di directory
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/Parameter Report Machine $mid.pdf');

//     // timpa file kosong dengan file pdf
//     await file.writeAsBytes(bytes);

//     //open pdf
//     await OpenFile.open(file.path);
//   }
// }

//--------------------------------------COST-------------------------------------------//
class CostMPDF {
  late int? mid;

  CostMPDF({this.mid});

  int i = 1;
  StreamController streamCostH = StreamController.broadcast();
  List<GetCostHModel> listCostH = [];
  GetCostHistori latestCostH = GetCostHistori();
  Future<void> costHData() async {
    listCostH = await latestCostH.getCostH(mid!);
    streamCostH.add(listCostH);
  }

  Future<void> AMRCS() async {
    await costHData();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "COST PRICE REPORT",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.Center(
              child: pw.Text(
                "MACHINE $mid",
                softWrap: true,
                style:
                    pw.TextStyle(fontBold: pw.Font.courierBold(), fontSize: 16),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "COST PRICE",
              softWrap: true,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(fontSize: 12),
              headerStyle:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: [
                'No',
                'Latest Update',
                'Type',
                'Good Processed',
                'Unit Price',
                'Total Price',
              ],
              data: listCostH
                  .map(
                    (e) => [
                      "${i++}",
                      (DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                          .parse(e.updatedAt!)
                          .toLocal()
                          .toString()
                          .split(' ')[0]),
                      "${e.tipe}",
                      "${e.good}",
                      "${e.harga_unit}",
                      "${e.total_harga}"
                    ],
                  )
                  .toList(),
            ),
          ];
        },
      ),
    ); // Page
    // SIMPAN
    Uint8List bytes = await pdf.save();

    // buat file kosong di directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Cost Price Report Machine $mid.pdf');

    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }
}
