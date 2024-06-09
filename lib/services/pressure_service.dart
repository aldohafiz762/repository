import 'dart:convert';
import 'package:project_tugas_akhir_copy/models/pressure_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetPressureGauge {
  Future getValue() async {
    final shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/pressureGauge");

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
    );
    Iterable it = (json.decode(response.body) as Map<String, dynamic>)["data"];
    List<PressureGauge> gaugeData =
        it.map((e) => PressureGauge.fromJSON(e)).toList();
    return gaugeData;
  }
}

class GetPressureChart {
  Future getPressure() async {
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/pressureChart");
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PressureModel> voltlist =
          it.map((e) => PressureModel.fromJSON(e)).toList();
      return voltlist;
    }
  }
}
