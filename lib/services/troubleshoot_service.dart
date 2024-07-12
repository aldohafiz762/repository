import 'package:project_tugas_akhir_copy/models/troubleshoot_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PostData {
  static Future<PostData> trigTB(int machine_id, String from, String otoritas,
      String to, String message) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/trigTB");

    var responsePost = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode({
        "machine_id": machine_id,
        "from": from,
        "otoritas": otoritas,
        "to": to,
        "message": message,
        "solved": false,
        "state": 1
      }),
    );
    if (responsePost.statusCode == 200) {
      print(200);
    }
    return PostData();
  }

  static Future sendMessage(
      int machine_id, String to, String message, String from) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/sendMessageTB?machine_id=$machine_id");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "from": from,
          "to": to,
          "message": message,
        }));
    if (response.statusCode == 200) {
      print(200);
    } else {
      print("fail");
    }
  }
}

class GetData {
  Future getRecTB(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/getTB?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });

    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetTB> TBLIst = it.map((e) => GetTB.fromJSON(e)).toList();
    return TBLIst;
  }
}

class UpdateData {
  static Future<UpdateData> updateTB(int machine_id, int idorder,
      String keterangan, bool solved, String to) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/updateTB?machine_id=$machine_id&idorder=$idorder");

    var responsePost = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode({
        "to": to,
        "keterangan": keterangan,
        "solved": solved,
      }),
    );
    if (responsePost.statusCode == 200) {
      print(200);
    }
    return UpdateData();
  }
}
