import 'dart:convert';

import 'package:project_tugas_akhir_copy/models/quality_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TrigQuality {
  late int? machine_id;
  late String? tipe;

  TrigQuality({this.machine_id, this.tipe});

  static Future<TrigQuality> triggerQuality(int machine_id, String tipe) async {
    Uri url = Uri.parse('https://semoga-lulus.vercel.app/api/trigQuality');
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");

    var trigResponse = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode(
        {
          "machine_id": machine_id,
          "tipe": tipe,
        },
      ),
    );
    var hasilresponse =
        (json.decode(trigResponse.body) as Map<String, dynamic>)['data'];
    return TrigQuality(
      machine_id: hasilresponse['machine_id'],
      tipe: hasilresponse['tipe'],
    );
  }
}

class GetQuality {
  late String? tipe;
  GetQuality({this.tipe});

  Future getQualityM(int machine_id, String tipe) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/getQualityData");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<CurrentQuality> qualityM1_A =
        it.map((e) => CurrentQuality.fromJSON(e)).toList();
    return qualityM1_A;
  }
}

class QualityDash {
  static List<DashQuality> _lastSuccessfulData =
      []; // Simpan data terakhir yang berhasil

  static Future<List<DashQuality>> dashQualityM() async {
    try {
      final SharedPreferences shared = await SharedPreferences.getInstance();
      var getToken = shared.getString("token");
      Uri url = Uri.parse("https://semoga-lulus.vercel.app/api/getQualityData");
      var hasilResponseGet = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });
      if (hasilResponseGet.statusCode == 200) {
        final parsed =
            json.decode(hasilResponseGet.body) as Map<String, dynamic>;
        final data = parsed["data"];

        if (data is List<dynamic>) {
          List<DashQuality> qualityList = data
              .map((e) => DashQuality.fromJSON(e as Map<String, dynamic>))
              .toList();
          _lastSuccessfulData =
              qualityList; // Update data terakhir yang berhasil
          return qualityList;
        } else if (data is Map<String, dynamic>) {
          DashQuality quality = DashQuality.fromJSON(data);
          _lastSuccessfulData = [quality]; // Update data terakhir yang berhasil
          return [quality];
        } else {
          throw Exception('Expected a list or map for "data"');
        }
      } else {
        throw Exception(
            'Failed to load status. Status code: ${hasilResponseGet.statusCode}, body: ${hasilResponseGet.body}');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
      return _lastSuccessfulData; // Kembalikan data terakhir yang berhasil diambil
    }
  }
}

class HistoryQuality {
  static Future<List<DashQuality>> historyQuality(int m_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://semoga-lulus.vercel.app/api/reportQuality?m_id=$m_id");

    try {
      var hasilResponseGet = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });

      if (hasilResponseGet.statusCode == 200) {
        final parsed =
            json.decode(hasilResponseGet.body) as Map<String, dynamic>;
        final data = parsed["data"];

        List<DashQuality> qualityList;

        if (data is List<dynamic>) {
          qualityList = data
              .map((e) => DashQuality.fromJSON(e as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic>) {
          qualityList = [DashQuality.fromJSON(data)];
        } else {
          throw Exception('Expected a list or map for "data"');
        }

        // Simpan data yang berhasil diambil ke SharedPreferences
        shared.setString('lastQualityData',
            json.encode(qualityList.map((e) => e.toJSON()).toList()));
        return qualityList;
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Exception caught: $e');

      // Ambil data terakhir yang disimpan dari SharedPreferences
      String? lastQualityData = shared.getString('lastQualityData');
      if (lastQualityData != null) {
        Iterable it = json.decode(lastQualityData);
        List<DashQuality> qualityList = it
            .map((e) => DashQuality.fromJSON(e as Map<String, dynamic>))
            .toList();
        return qualityList;
      } else {
        throw Exception('No previous data available');
      }
    }
  }
}

class RecordQuality {
  Future getrecQuality(int m_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://semoga-lulus.vercel.app/api/getRecQuality?m_id=$m_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<RecQuality> reqQyalityM =
        it.map((e) => RecQuality.fromJSON(e)).toList();
    return reqQyalityM;
  }
}

class InputDefect {
  late int? defect, machine_id;
  late String? tipe;
  InputDefect({this.defect});

  static Future<InputDefect> defectQuality(int defect) async {
    Uri url = Uri.parse('https://semoga-lulus.vercel.app/api/inputDefect');
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");

    var defectresponse = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode(
        {
          "defect": defect,
        },
      ),
    );
    var hasilresponse =
        (json.decode(defectresponse.body) as Map<String, dynamic>)['data'];
    return InputDefect(defect: hasilresponse['defect']);
  }
}

class ResetQuality {
  late int? machine_id;

  ResetQuality({this.machine_id});
  static Future<ResetQuality> reset(int machine_id) async {
    Uri url = Uri.parse(
        'https://semoga-lulus.vercel.app/api/resetQuality?m_id=$machine_id');
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var resetResponse = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
    );
    var hasilresponse =
        (json.decode(resetResponse.body) as Map<String, dynamic>)['data'];
    return ResetQuality(machine_id: hasilresponse['machine_id']);
  }
}
