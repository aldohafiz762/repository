import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_tugas_akhir_copy/models/preventive_model.dart';

class UpdatePreventiveMessage {
  static Future<UpdatePreventiveMessage> updateMessage(
      int machine_id, int id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/updatePrevStatus?machine_id=$machine_id");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          // "keterangan": "Solved",
          "idpreventive": id,
        }));
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    return UpdatePreventiveMessage();
  }
}

class UpdateJadwalPreventive {
  static Future<UpdateJadwalPreventive> updateJadwal(
      int machine_id, String hari, String jam, String menit) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://tugasakhirmangjody.my.id/api/updateJadwalPrev");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "machine_id": machine_id,
          "hari": hari,
          "jam": jam,
          "menit": menit,
        }));
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    return UpdateJadwalPreventive();
  }
}

class BuatJadwal {
  static Future<BuatJadwal> createJadwal(
      int komponen_id, String description) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/createJadwal");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "komponen_id": komponen_id,
          "description": description,
          // "jam": jam,
          // "menit": menit,
        }));
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    return BuatJadwal();
  }
}

class GetJadwalPrev {
  Future getJadwal() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/getJadwalPrev");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<PreventiveScheduleModel> prevSchedule =
        it.map((e) => PreventiveScheduleModel.fromJSON(e)).toList();
    return prevSchedule;
  }

  Future getSingleJadwal() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/getJadwalPrev");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    var hasilResponse = json.decode(hasilResponseGet.body)['data'];
    return hasilResponse;
  }
}

class GetAlarmSensor {
  Future getPrev(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/getAlarmSensor?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<PreventiveMessageModel> prevMessage =
        it.map((e) => PreventiveMessageModel.fromJSON(e)).toList();
    return prevMessage;
  }
}

class GetAlarmRepair {
  Future getPrev(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/getAlarmRepair?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<PreventiveMessageModel> prevMessage =
        it.map((e) => PreventiveMessageModel.fromJSON(e)).toList();
    return prevMessage;
  }
}

class GetAlarmStock {
  Future getPrev(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/getAlarmStock?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<PreventiveMessageModel> prevMessage =
        it.map((e) => PreventiveMessageModel.fromJSON(e)).toList();
    return prevMessage;
  }
}
