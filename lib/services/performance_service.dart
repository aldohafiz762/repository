import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_tugas_akhir_copy/models/performance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrigPerformance {
  static Future<TrigPerformance> triggerPerformance(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/trigPerformance");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (response.statusCode == 200) {
      print(response.statusCode);
    }
    return TrigPerformance();
  }
}

class ResetPerformance {
  static Future<ResetPerformance> resPerformance(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/resetPerformance");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (response.statusCode == 200) {
      print(response.statusCode);
    }
    return ResetPerformance();
  }
}

class GetPerformance {
  Future getPerform(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/latestPerformance?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetPerformanceModel> getPerformm =
        it.map((e) => GetPerformanceModel.fromJSON(e)).toList();
    return getPerformm;
  }
}
