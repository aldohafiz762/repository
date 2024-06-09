import 'dart:convert';

import 'package:project_tugas_akhir_copy/models/costprice_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetPrice {
  Future getPriceList() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getPrice");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetPriceModel> pricelist =
        it.map((e) => GetPriceModel.FromJSON(e)).toList();
    return pricelist;
  }
}

class TriggCost {
  static Future<TriggCost> trigCost(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/trigCost");
    var hasilResponseGet = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({"machine_id": machine_id}));
    if (hasilResponseGet.statusCode == 200) {
      print(200);
    }
    return TriggCost();
  }
}

class GetLatestCost {
  Future getCostList(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/getCost?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetCostModel> Costlist =
        it.map((e) => GetCostModel.FromJSON(e)).toList();
    return Costlist;
  }
}

class GetDashCost {
  Future getCostDash() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getDashCost");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetCostdashModel> Costlist =
        it.map((e) => GetCostdashModel.FromJSON(e)).toList();
    return Costlist;
  }
}

class GetCostHistori {
  Future getCostH(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/getCostHistori?machine_id=$machine_id");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<GetCostHModel> Costlist =
        it.map((e) => GetCostHModel.FromJSON(e)).toList();
    return Costlist;
  }
}

class ResetCost {
  static Future<ResetCost> resettCost(int machine_id) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse(
        "https://bismillah-lulus-ta.vercel.app/api/resetCost?machine_id=$machine_id");
    var hasilResponseGet = await http.put(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (hasilResponseGet.statusCode == 200) {
      print(200);
    }
    return ResetCost();
  }
}

class UpdateHarga {
  static Future<UpdateHarga> newHarga(
      String tipe, int baku1, int baku2, int baku3) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/updatePrice");
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "tipe": tipe,
          "price_baku1": baku1,
          "price_baku2": baku2,
          "price_baku3": baku3,
        }));
    if (response.statusCode == 200) {
      print(200);
    } else {
      print(response.statusCode);
    }
    return UpdateHarga();
  }
}
