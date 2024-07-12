import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_tugas_akhir_copy/models/bigloss_model.dart';

class DashBL {
  static Future<List<DashBLModel>> dashBL() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/getdashBL");
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
        List<DashBLModel> getbl = data
            .map((e) => DashBLModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return getbl;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [DashBLModel.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }
}

class HistoryBL {
  static Future<List<DashBLModel>> historyBL() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/getBLHistori");
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
        List<DashBLModel> getbl = data
            .map((e) => DashBLModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return getbl;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [DashBLModel.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
    // Iterable it =
    //     (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    // List<OEEdashModel> getoee =
    //     it.map((e) => OEEdashModel.FromJSON(e)).toList();
    // return getoee;
  }
}
