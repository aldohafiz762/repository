import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tugas_akhir_copy/models/availability_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetAvailability {
  static Future<void> saveLastData(List<AvaiModelM> data) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    List<String> jsonData = data.map((e) => json.encode(e.toJSON())).toList();
    await shared.setStringList("lastData", jsonData);
  }

  static Future<List<AvaiModelM>> getLastData() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    List<String>? jsonData = shared.getStringList("lastData");
    if (jsonData != null) {
      return jsonData.map((e) => AvaiModelM.fromJSON(json.decode(e))).toList();
    }
    return [];
  }

  static Future<List<AvaiModelM>> availabilityM() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://semoga-lulus.vercel.app/api/latestAvailability");
    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as Map<String, dynamic>;
        final data = parsed["data"];

        List<AvaiModelM> aList;
        if (data is List<dynamic>) {
          aList = data
              .map((e) => AvaiModelM.fromJSON(e as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic>) {
          aList = [AvaiModelM.fromJSON(data)];
        } else {
          throw Exception('Expected a list or map for "data"');
        }
        await saveLastData(aList);
        return aList;
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Error occurred: $e');
      return await getLastData();
    }
  }
}

Future getState(int machine_id) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  var getToken = shared.getString("token");
  Uri url = Uri.parse(
      "https://semoga-lulus.vercel.app/api/latestAvailability?machine_id=$machine_id");
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Basic $getToken'
  });
  final data = (json.decode(response.body) as Map<String, dynamic>)['data'];
  final int state = data[0]['state'];
  return state;
}

class TrigAvailability {
  static Future triggerAvai(int machine_id, int state) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/trigAvailability");
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
        Uri.parse("https://semoga-lulus.vercel.app/api/resetAvailability");
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
