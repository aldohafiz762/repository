import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:project_tugas_akhir_copy/services/preventive_service.dart';
import 'package:project_tugas_akhir_copy/models/preventive_model.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportMaintenance {
  late int? mid;

  ReportMaintenance({this.mid});

  int i = 1;
  final timeZone = tz.getLocation('Asia/Jakarta');
  late Timer timer;
  StreamController streamPrev = StreamController.broadcast();
  List<PreventiveMessageModel> ListPrev = [];
  GetPreventive prevList = GetPreventive();
  Future<void> prevData() async {
    ListPrev = await prevList.getPrev(mid!);
    streamPrev.add(ListPrev);
  }

  Future<void> Trouble() async {
    await prevData();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                "Prevenyive Maintenance Report",
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
              "Maintenance Schedule",
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
                  'Id Order',
                  'Message',
                  'Order Date',
                  'Done Date',
                  'Status'
                ],
                data: ListPrev.map((e) {
                  //FORMAT TANGGAL ASIA/JAKARTA
                  final TScreatedAt = DateTime.parse(e.createdAt!);
                  final NowCreatedAt =
                      tz.TZDateTime.from(TScreatedAt, timeZone);
                  final TSupdatedAt = DateTime.parse(e.updatedAt!);
                  final NowupdatedAt =
                      tz.TZDateTime.from(TSupdatedAt, timeZone);
                  final formatter = DateFormat('dd-MM-yyyy hh:mm:ss a');
                  final createdAtFix = formatter.format(NowCreatedAt);
                  final updatedAtFix = formatter.format(NowupdatedAt);
                  return [
                    '${i++}',
                    '${e.idpreventive}',
                    '${e.message}',
                    createdAtFix,
                    updatedAtFix,
                    '${e.keterangan}',
                  ];
                }).toList()),
          ];
        },
      ),
    ); // Page
    // SIMPAN
    Uint8List bytes = await pdf.save();

    // buat file kosong di directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Preventive Machine $mid.pdf');

    // timpa file kosong dengan file pdf
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }
}
