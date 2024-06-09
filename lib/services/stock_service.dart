import 'package:http/http.dart' as http;
import 'package:project_tugas_akhir_copy/models/stock_model.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

//Read Data Stock M
class ReadStock {
  Future getStock(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/getStock?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });

    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<StockModel> stockList = it.map((e) => StockModel.fromJSON(e)).toList();
    return stockList;
  }

  //REPORT
  Future getallStock() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/allStock");
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
  late int? A, B, C, machine_id;
  late String? id;

  AddStock({this.A, this.B, this.C, this.id, this.machine_id});

  static Future<AddStock> putStock(int A, int B, int C, int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/addStock?m_id=$machine_id");

    var hasilResponsePut = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode({"A": A, "B": B, "C": C}),
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
      A: dataPut["A"],
      B: dataPut["B"],
      C: dataPut["C"],
    );
  }
}

//RIWAYAT STOCK------------------------------------------------------------------------
class AddriwayatStock {
  late int? jumlah, machine_id;
  late String? id, tipe;

  AddriwayatStock({this.jumlah, this.machine_id, this.id, this.tipe});
  static Future<AddriwayatStock> connectAPIPost(
      int machine_id, String tipe, int jumlah) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/inputStock");

    var hasilResponsePost = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "machine_id": machine_id,
          "tipe": tipe,
          "jumlah": jumlah,
        }));
    print(hasilResponsePost.statusCode);
    var data = (json.decode(hasilResponsePost.body) as Map<String, dynamic>);
    return AddriwayatStock(
        machine_id: data["machine_id"],
        tipe: data["tipe"],
        jumlah: data["jumlah"],
        id: data["_id"]);
  }
}

class Getriwayat {
  Future gethistori(int m_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/historiStock?m_id=$m_id");
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
