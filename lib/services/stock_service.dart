import 'package:http/http.dart' as http;
import 'package:project_tugas_akhir_copy/models/stock_model.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

//Read Data Stock M
class ReadStock {
  static Future<List<StockModel>> getStock(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/getStock?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });

    if (hasilResponseGet.statusCode == 200) {
      final parsed = json.decode(hasilResponseGet.body) as Map<String, dynamic>;
      print('Parsed JSON: $parsed'); // Debug log untuk memeriksa struktur JSON
      final data = parsed["data"];
      print('Data: $data'); // Debug log untuk memeriksa isi "data"

      if (data is List<dynamic>) {
        List<StockModel> getoee = data
            .map((e) => StockModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return getoee;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [StockModel.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }

  //HISTORY STOCK
  static Future<List<StockModel>> historyStock() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/reportStock");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });

    if (hasilResponseGet.statusCode == 200) {
      final parsed = json.decode(hasilResponseGet.body) as Map<String, dynamic>;
      print('Parsed JSON: $parsed'); // Debug log untuk memeriksa struktur JSON
      final data = parsed["data"];
      print('Data: $data'); // Debug log untuk memeriksa isi "data"

      if (data is List<dynamic>) {
        List<StockModel> getoee = data
            .map((e) => StockModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return getoee;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [StockModel.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }

  //REPORT
  Future getallStock() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/allStock");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });

    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<AllstockModel> stockList =
        it.map((e) => AllstockModel.fromJSON(e)).toList();
    return stockList;
  }
}

//Tambah Stock M1
class AddStock {
  late int? stock, machine_id;
  late String? id, sent;

  AddStock({this.stock, this.id, this.machine_id, this.sent});

  static Future<AddStock> putStock(int stock, int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");

    // Mendapatkan waktu sekarang
    String now = DateTime.now().toUtc().toIso8601String();

    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/addStock?m_id=$machine_id");

    var hasilResponsePut = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode({
        "stock": stock,
        "sent": now, // Menambahkan waktu sekarang ke dalam body permintaan
      }),
    );

    var dataPut =
        (json.decode(hasilResponsePut.body) as Map<String, dynamic>)['data'];

    if (hasilResponsePut.statusCode == 200) {
      print(hasilResponsePut.statusCode);
    } else {
      print(hasilResponsePut.statusCode);
    }

    return AddStock(
      id: dataPut["_id"],
      machine_id: dataPut["machine_id"],
      stock: dataPut["stock"],
      sent: dataPut["sent"], // Menyimpan waktu sekarang
    );
  }
}

//RIWAYAT STOCK------------------------------------------------------------------------
class AddriwayatStock {
  late int? jumlah, machine_id;
  late String? id;

  AddriwayatStock({this.jumlah, this.machine_id, this.id});
  static Future<AddriwayatStock> connectAPIPost(
      int machine_id, int jumlah) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/inputStock");

    var hasilResponsePost = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "machine_id": machine_id,
          // "stock": stock,
          "jumlah": jumlah,
        }));
    print(hasilResponsePost.statusCode);
    var data = (json.decode(hasilResponsePost.body) as Map<String, dynamic>);
    return AddriwayatStock(
        machine_id: data["machine_id"],
        // tipe: data["tipe"],
        jumlah: data["jumlah"],
        id: data["_id"]);
  }
}

class Getriwayat {
  Future gethistori(int m_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/historiStock?m_id=$m_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<Historimodel> historiM1List =
        it.map((e) => Historimodel.fromJSON(e)).toList();
    return historiM1List;
  }
}
