import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_tugas_akhir_copy/models/bigloss_model.dart';

class DashBL {
  static Future<List<DashBLModel>> dashBL() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/getdashBL");

    try {
      var hasilResponseGet = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });

      if (hasilResponseGet.statusCode == 200) {
        final parsed =
            json.decode(hasilResponseGet.body) as Map<String, dynamic>;
        print(
            'Parsed JSON: $parsed'); // Debug log untuk memeriksa struktur JSON
        final data = parsed["data"];
        print('Data: $data'); // Debug log untuk memeriksa isi "data"

        if (data is List<dynamic>) {
          List<DashBLModel> getbl = data
              .map((e) => DashBLModel.fromJSON(e as Map<String, dynamic>))
              .toList();

          // Simpan data ke SharedPreferences
          await shared.setString('lastData', json.encode(data));

          return getbl;
        } else if (data is Map<String, dynamic>) {
          List<DashBLModel> getbl = [DashBLModel.fromJSON(data)];

          // Simpan data ke SharedPreferences
          await shared.setString('lastData', json.encode(data));

          return getbl;
        } else {
          throw Exception('Expected a list or map for "data"');
        }
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Error: $e'); // Debug log untuk memeriksa kesalahan

      // Ambil data terakhir dari SharedPreferences
      var lastData = shared.getString('lastData');
      if (lastData != null) {
        final data = json.decode(lastData);

        if (data is List<dynamic>) {
          List<DashBLModel> getbl = data
              .map((e) => DashBLModel.fromJSON(e as Map<String, dynamic>))
              .toList();
          return getbl;
        } else if (data is Map<String, dynamic>) {
          return [DashBLModel.fromJSON(data)];
        } else {
          throw Exception('Expected a list or map for "data"');
        }
      } else {
        throw Exception('Failed to load status and no cached data available');
      }
    }
  }
}

class HistoryBL {
  static Future<List<DashBLModel>> historyBL() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/getBLHistori");

    try {
      var hasilResponseGet = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });

      if (hasilResponseGet.statusCode == 200) {
        final parsed =
            json.decode(hasilResponseGet.body) as Map<String, dynamic>;
        print(
            'Parsed JSON: $parsed'); // Debug log untuk memeriksa struktur JSON
        final data = parsed["data"];
        print('Data: $data'); // Debug log untuk memeriksa isi "data"

        List<DashBLModel> blList;

        if (data is List<dynamic>) {
          blList = data
              .map((e) => DashBLModel.fromJSON(e as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic>) {
          blList = [DashBLModel.fromJSON(data)];
        } else {
          throw Exception('Expected a list or map for "data"');
        }

        // Simpan data yang berhasil diambil ke SharedPreferences
        shared.setString(
            'lastBLData', json.encode(blList.map((e) => e.toJSON()).toList()));
        return blList;
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Exception caught: $e');

      // Ambil data terakhir yang disimpan dari SharedPreferences
      String? lastBLData = shared.getString('lastBLData');
      if (lastBLData != null) {
        Iterable it = json.decode(lastBLData);
        List<DashBLModel> blList = it
            .map((e) => DashBLModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return blList;
      } else {
        throw Exception('No previous data available');
      }
    }
  }
}
