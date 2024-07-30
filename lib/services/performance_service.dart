import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_tugas_akhir_copy/models/performance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrigPerformance {
  static Future<TrigPerformance> triggerPerformance(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/trigPerformance");
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
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/resetPerformance");
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
  static Future<List<GetPerformanceModel>> getPerform() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://semoga-lulus.vercel.app/api/latestPerformance");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    // Iterable it =
    //     (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    // List<GetPerformanceModel> getPerformm =
    //     it.map((e) => GetPerformanceModel.fromJSON(e)).toList();
    // return getPerformm;
    if (hasilResponseGet.statusCode == 200) {
      final parsed = json.decode(hasilResponseGet.body) as Map<String, dynamic>;
      final data = parsed["data"];

      if (data is List<dynamic>) {
        List<GetPerformanceModel> pList = data
            .map((e) => GetPerformanceModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return pList;
      } else if (data is Map<String, dynamic>) {
        GetPerformanceModel pList = GetPerformanceModel.fromJSON(data);
        // print("data: $status");
        return [pList];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }
}
