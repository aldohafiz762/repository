import 'dart:convert';

import 'package:project_tugas_akhir_copy/models/status_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetStatusDash {
  late int? status;
  late String? id;

  GetStatusDash({this.status, this.id});

  static Future<List<DashStatusModel>> fetchStatusData() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getStatusDash");

    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    // var statusList = DashStatusModel.fromJSON(
    //     (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"]);
    // var it =
    //     (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    // List<DashStatusModel> statusList =
    //     it.map((e) => DashStatusModel.fromJSON(e)).toList();
    // return statusList;
    if (hasilResponseGet.statusCode == 200) {
      List<DashStatusModel> data = jsonDecode(hasilResponseGet.body)['data'];
      return data;
      // .map((item) => DashStatusModel.fromJSON(item)).toList();
    } else {
      throw Exception('Failed to load status data');
    }
    // Iterable it =
    //     (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    // List<StatusModel> statusList =
    //     it.map((e) => StatusModel.fromJSON(e)).toList();
    // return statusList;
  }
}

class GetStatusM1 {
  late int? status;

  GetStatusM1({this.status});

  static Future readStatM1() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url =
        Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getStatusM1");

    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (hasilResponseGet.statusCode == 200) {
      final parsed = json.decode(hasilResponseGet.body) as Map<String, dynamic>;
      final data = parsed["data"];

      if (data is List<dynamic>) {
        List<Status1Model> statusList = data
            .map((e) => Status1Model.fromJSON(e as Map<String, dynamic>))
            .toList();
        return statusList;
      } else if (data is Map<String, dynamic>) {
        // Jika data adalah Map, perlakukan dengan benar atau lempar pengecualian
        return [Status1Model.fromJSON(data)];
      } else {
        throw Exception('Expected a list or map for "data"');
      }
    } else {
      throw Exception('Failed to load status');
    }
  }
}
// }

// class GetStatusM2 {
//   late int? machine_id, status;

//   GetStatusM2({this.machine_id, this.status});

//   static Future readStatM2() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     Uri url =
//         Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getStatusM2");

//     var hasilResponseGet = await http.get(url, headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it =
//         (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<status2Model> statusList =
//         it.map((e) => status2Model.fromJSON(e)).toList();
//     return statusList;
//   }
// }

// class GetStatusM3 {
//   late int? machine_id, status;

//   GetStatusM3({this.machine_id, this.status});

//   static Future readStatM3() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     Uri url =
//         Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getStatusM3");

//     var hasilResponseGet = await http.get(url, headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it =
//         (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<status3Model> statusList =
//         it.map((e) => status3Model.fromJSON(e)).toList();
//     return statusList;
//   }
// }

// class GetStatusM4 {
//   late int? machine_id, status;

//   GetStatusM4({this.machine_id, this.status});

//   static Future readStatM4() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     Uri url =
//         Uri.parse("https://bismillah-lulus-ta.vercel.app/api/getStatusM4");

//     var hasilResponseGet = await http.get(url, headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it =
//         (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<status4Model> statusList =
//         it.map((e) => status4Model.fromJSON(e)).toList();
//     return statusList;
//   }
// }
