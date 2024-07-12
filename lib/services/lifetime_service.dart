import 'dart:convert';

import 'package:project_tugas_akhir_copy/models/lifetime_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetOneLT {
  Future getOne(int komponen_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/getOneLT?komponen_id=$komponen_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (hasilResponseGet.statusCode == 200) {
      final parsed = json.decode(hasilResponseGet.body) as Map<String, dynamic>;
      final data = parsed["data"];

      if (data is List<dynamic>) {
        List<LifetimeModel> ltList = data
            .map((e) => LifetimeModel.fromJSON(e as Map<String, dynamic>))
            .toList();
        return ltList;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [LifetimeModel.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }
}

class GetAllLT {
  Future getAll() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/getAllLT");
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
  static Future<UpdateLT> updateUmur(int komponen_id, int timevalue) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://tugasakhirmangjody.my.id/api/updateLT?komponen_id=$komponen_id");
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
