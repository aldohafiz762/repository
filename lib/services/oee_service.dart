import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tugas_akhir_copy/models/oee_model.dart';

class GetOEE {
  Future getResult(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://semoga-lulus.vercel.app/api/getOEE?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (hasilResponseGet.statusCode == 200) {
      Iterable it =
          (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
      List<GetOEEModel> getoee =
          it.map((e) => GetOEEModel.FromJSON(e)).toList();
      return getoee;
    } else {
      print('Failed to load data: ${hasilResponseGet.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  static Future<List<OEEdashModel>> dashOEE() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/getdashOEE");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (hasilResponseGet.statusCode == 200) {
      final parsed = json.decode(hasilResponseGet.body) as Map<String, dynamic>;
      print('Parsed JSON: $parsed'); // Debug log untuk memeriksa struktur JSON
      final data = parsed["data"];
      print('Data: $data'); // Debug log untuk memeriksa isi "data"

      List<OEEdashModel> getoee;

      if (data is List<dynamic>) {
        getoee = data
            .map((e) => OEEdashModel.FromJSON(e as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic>) {
        getoee = [OEEdashModel.FromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }

      // Simpan data terbaru ke SharedPreferences
      shared.setString(
          'lastOEEData', json.encode(getoee.map((e) => e.toJson()).toList()));

      return getoee;
    } else {
      print('Failed to load status: ${hasilResponseGet.statusCode}');
      // Coba memuat data dari SharedPreferences
      String? lastOEEData = shared.getString('lastOEEData');
      if (lastOEEData != null) {
        List<dynamic> jsonData = json.decode(lastOEEData);
        return jsonData.map((e) => OEEdashModel.FromJSON(e)).toList();
      } else {
        throw Exception('Failed to load status and no cached data available');
      }
    }
  }
}

class OEEHistori {
  static Future<List<OEEdashModel>> historyOEE() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/getOEEHistori");

    try {
      var hasilResponseGet = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });

      if (hasilResponseGet.statusCode == 200) {
        Iterable it = (json.decode(hasilResponseGet.body)
            as Map<String, dynamic>)["data"];
        List<OEEdashModel> getoee =
            it.map((e) => OEEdashModel.FromJSON(e)).toList();

        // Simpan data yang berhasil diambil ke SharedPreferences
        shared.setString('lastOEEData', json.encode(it.toList()));

        return getoee;
      } else {
        print('Failed to load history: ${hasilResponseGet.statusCode}');
        throw Exception('Failed to load history');
      }
    } catch (e) {
      print('Exception caught: $e');

      // Ambil data terakhir yang disimpan dari SharedPreferences
      String? lastOEEData = shared.getString('lastOEEData');
      if (lastOEEData != null) {
        Iterable it = json.decode(lastOEEData);
        List<OEEdashModel> getoee =
            it.map((e) => OEEdashModel.FromJSON(e)).toList();
        return getoee;
      } else {
        throw Exception('No previous data available');
      }
    }
  }
}

class TrigOEE {
  static Future<TrigOEE> triggerOEE(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/trigOEE");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (response.statusCode == 200) {
      print('Trigger OEE succeeded with status code: ${response.statusCode}');
    } else {
      print('Trigger OEE failed with status code: ${response.statusCode}');
      throw Exception('Failed to trigger OEE');
    }
    return TrigOEE();
  }
}

class ResetOEE {
  static Future<ResetOEE> resOEE(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/resetOEE");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (response.statusCode == 200) {
      print('Reset OEE succeeded with status code: ${response.statusCode}');
    } else {
      print('Reset OEE failed with status code: ${response.statusCode}');
      throw Exception('Failed to reset OEE');
    }
    return ResetOEE();
  }
}
