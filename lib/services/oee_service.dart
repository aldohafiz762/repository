import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_tugas_akhir_copy/models/oee_model.dart';

class GetOEE {
  Future getResult(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/getOEE?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetOEEModel> getoee = it.map((e) => GetOEEModel.FromJSON(e)).toList();
    return getoee;
  }

  Future dashOEE() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getdashOEE");
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
        List<OEEdashModel> getoee = data
            .map((e) => OEEdashModel.FromJSON(e as Map<String, dynamic>))
            .toList();
        return getoee;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [OEEdashModel.FromJSON(data)];
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

class OEEHistori {
  Future historyOEE(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/getOEEHistori?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<OEEHistoriModel> getoee =
        it.map((e) => OEEHistoriModel.FromJSON(e)).toList();
    return getoee;
  }
}

class TrigOEE {
  static Future<TrigOEE> triggerOEE(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/trigOEE");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (response.statusCode == 200) {
      print(response.statusCode);
    }
    return TrigOEE();
  }
}

class ResetOEE {
  static Future<ResetOEE> resOEE(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/resetOEE");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (response.statusCode == 200) {
      print(response.statusCode);
    }
    return ResetOEE();
  }
}
