import 'dart:convert';

import 'package:project_tugas_akhir_copy/models/lifetime_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetOneLT {
  Future getOne(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/getOneLT?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    final data =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    final int LT = data['timevalue'];
    return LT;
  }
}

class GetAllLT {
  Future getAll() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getAllLT");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<LifetimeModel> LTList =
        it.map((e) => LifetimeModel.fromJSON(e)).toList();
    return LTList;
  }
}

class UpdateLT {
  static Future<UpdateLT> updateUmur(int machine_id, int timevalue) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/updateLT?machine_id=$machine_id");
    var responseUpdate = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode(
        {
          "timevalue": timevalue,
        },
      ),
    );
    if (responseUpdate.statusCode == 200) {
      print(200);
    }
    return UpdateLT();
  }
}
