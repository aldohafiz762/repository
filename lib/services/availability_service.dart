import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tugas_akhir_copy/models/availability_model.dart';

class GetAvailability {
  static Future<List<AvaiModelM>> availabilityM() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://tugasakhirmangjody.my.id/api/latestAvailability");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    // Iterable it = (json.decode(response.body) as Map<String, dynamic>)["data"];
    // List<AvaiModelM> aList = it.map((e) => AvaiModelM.fromJSON(e)).toList();
    // return aList;
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body) as Map<String, dynamic>;
      final data = parsed["data"];

      if (data is List<dynamic>) {
        List<AvaiModelM> aList = data
            .map((e) => AvaiModelM.fromJSON(e as Map<String, dynamic>))
            .toList();
        return aList;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [AvaiModelM.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }

  Future getState(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/latestAvailability?machine_id=$machine_id");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    final data = (json.decode(response.body) as Map<String, dynamic>)['data'];
    final int state = data[0]['state'];
    return state;
  }
}

class TrigAvailability {
  static Future triggerAvai(int machine_id, int state) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://tugasakhirmangjody.my.id/api/trigAvailability");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode({
        "machine_id": machine_id,
        "state": state,
      }),
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print("Gagal");
    }
  }
}

class ResetAvailability {
  static Future resetAvai(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://tugasakhirmangjody.my.id/api/resetAvailability");
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode({
        "machine_id": machine_id,
      }),
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print("Gagal");
    }
  }
}
