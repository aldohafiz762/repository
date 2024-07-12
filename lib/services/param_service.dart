import 'dart:convert';

import 'package:project_tugas_akhir_copy/models/param_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//INPUT PARAMETER
class InputParameter {
  late String? machine_id, loading_time, cycle_time, oee_target, harga_perUnit;
  late String? tipe_benda;

  InputParameter(
      {this.machine_id,
      this.loading_time,
      this.cycle_time,
      this.oee_target,
      this.harga_perUnit,
      this.tipe_benda});

  //MACHINE 1
  static Future<InputParameter> insertParam(
      String machine_id,
      String loading_time,
      String cycle_time,
      String oee_target,
      String tipe_benda,
      int state) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/inputParam");

    var hasilResponsePost = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Basic $getToken'
        },
        body: jsonEncode({
          "machine_id": machine_id,
          "loading_time": loading_time,
          "cycle_time": cycle_time,
          "oee_target": oee_target,
          "tipe_benda": tipe_benda,
          "state": state
        }));
    print(hasilResponsePost.statusCode);
    return InputParameter();
  }
  //MACHINE 2
  // static Future<InputParameter> insertParam2(
  //     String machine_id,
  //     String loading_time,
  //     String cycle_time,
  //     String oee_target,
  //     String tipe_benda,
  //     int state) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //       var getToken = shared.getString("token");
  //   Uri url = Uri.parse("https://berli.aplikasipms.com/api/inputParam");

  //   var hasilResponsePost = await http.post(url,
  //       headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $getToken' },
  //       body: jsonEncode({
  //         "machine_id": machine_id,
  //         "loading_time": loading_time,
  //         "cycle_time": cycle_time,
  //         "oee_target": oee_target,
  //         "tipe_benda": tipe_benda,
  //         "state": state
  //       }));
  //   print(hasilResponsePost.statusCode);
  //   return InputParameter();
  // }
  // //MACHINE 3
  // static Future<InputParameter> insertParam3(
  //     String machine_id,
  //     String loading_time,
  //     String cycle_time,
  //     String oee_target,
  //     String tipe_benda,
  //     int state) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //       var getToken = shared.getString("token");
  //   Uri url = Uri.parse("https://berli.aplikasipms.com/api/inputParam");

  //   var hasilResponsePost = await http.post(url,
  //       headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $getToken' },
  //       body: jsonEncode({
  //         "machine_id": machine_id,
  //         "loading_time": loading_time,
  //         "cycle_time": cycle_time,
  //         "oee_target": oee_target,
  //         "tipe_benda": tipe_benda,
  //         "state": state
  //       }));
  //   print(hasilResponsePost.statusCode);
  //   return InputParameter();
  // }
  // //MACHINE 4
  // static Future<InputParameter> insertParam4(
  //     String machine_id,
  //     String loading_time,
  //     String cycle_time,
  //     String oee_target,
  //     String tipe_benda,
  //     int state) async {
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //       var getToken = shared.getString("token");
  //   Uri url = Uri.parse("https://berli.aplikasipms.com/api/inputParam");

  //   var hasilResponsePost = await http.post(url,
  //       headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'Basic $getToken' },
  //       body: jsonEncode({
  //         "machine_id": machine_id,
  //         "loading_time": loading_time,
  //         "cycle_time": cycle_time,
  //         "oee_target": oee_target,
  //         "tipe_benda": tipe_benda,
  //         "state": state
  //       }));
  //   print(hasilResponsePost.statusCode);
  //   return InputParameter();
  // }
}

// RESET PARAMATER M1
class ResetParam {
  late int? state;

  ResetParam({this.state});

  static Future<ResetParam> putParam(int state) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    shared.setInt('stateParamM1', state);
    Uri urlput = Uri.parse("https://tugasakhirmangjody.my.id/api/resetParamM1");

    var hasilResponsePut = await http.put(
      urlput,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      },
      body: jsonEncode(
        {
          "state": state,
        },
      ),
    );
    var dataPut =
        (jsonDecode(hasilResponsePut.body) as Map<String, dynamic>)['data'];

    return ResetParam(state: dataPut['state']);
  }
}

// RESET PARAMATER M2
// class resetParamM2 {
//   late int? state;

//   resetParamM2({this.state});

//   static Future<resetParamM2> putParam(int state) async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//         var getToken = shared.getString("token");
//         shared.setInt('stateParamM2',state);
//     Uri urlput = Uri.parse("https://berli.aplikasipms.com/api/resetParamM2");

//     var hasilResponsePut = await http.put(
//       urlput,
//       headers: <String, String>{'Content-Type': 'application/json','Authorization': 'Basic $getToken'},
//       body: jsonEncode(
//         {
//           "state": state,
//         },
//       ),
//     );
//     var dataPut = (jsonDecode(hasilResponsePut.body) as Map<String, dynamic>)['data'];

//     return resetParamM2(
//       state: dataPut['state']
//     );
//   }
// }

// // RESET PARAMATER M3
// class resetParamM3 {
//   late int? state;

//   resetParamM3({this.state});

//   static Future<resetParamM3> putParam(int state) async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//         var getToken = shared.getString("token");
//         shared.setInt('stateParamM3',state);
//     Uri urlput = Uri.parse("https://berli.aplikasipms.com/api/resetParamM3");

//     var hasilResponsePut = await http.put(
//       urlput,
//       headers: <String, String>{'Content-Type': 'application/json','Authorization': 'Basic $getToken'},
//       body: jsonEncode(
//         {
//           "state": state,
//         },
//       ),
//     );
//     var dataPut = (jsonDecode(hasilResponsePut.body) as Map<String, dynamic>)['data'];

//     return resetParamM3(
//       state: dataPut['state']
//     );
//   }
// }
// // RESET PARAMATER M4
// class resetParamM4 {
//   late int? state;

//   resetParamM4({this.state});

//   static Future<resetParamM4> putParam(int state) async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//         var getToken = shared.getString("token");
//         shared.setInt('stateParamM4',state);
//     Uri urlput = Uri.parse("https://berli.aplikasipms.com/api/resetParamM4");

//     var hasilResponsePut = await http.put(
//       urlput,
//       headers: <String, String>{'Content-Type': 'application/json','Authorization': 'Basic $getToken'},
//       body: jsonEncode(
//         {
//           "state": state,
//         },
//       ),
//     );
//     var dataPut = (jsonDecode(hasilResponsePut.body) as Map<String, dynamic>)['data'];

//     return resetParamM4(
//       state: dataPut['state']
//     );
//   }
// }

// //Report
// class reportParam {
//   Uri url = Uri.parse("https://berli.aplikasipms.com/api/reportParam");
//   Future getParam() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     var hasilResponseGet = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it = (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<paramReportModel> paramList = it.map((e) => paramReportModel.fromJSON(e)).toList();
//     return paramList;
//   }
// }

// //Histori
// class HistoriParam {
//   Future getParam(int machine_id) async {
//     Uri url = Uri.parse("https://berli.aplikasipms.com/api/getParamHistori?machine_id=$machine_id");
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     var hasilResponseGet = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it = (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<paramReportModel> paramList = it.map((e) => paramReportModel.fromJSON(e)).toList();
//     return paramList;
//   }
// }

//READ LATEST INPUT PARAMETER M1
class ReadLatestParamM1 {
  Uri url = Uri.parse("https://tugasakhirmangjody.my.id/api/latestParamM1");
  Future getParamM1() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var hasilResponseGet = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    Iterable it =
        (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
    List<ParamModel> paramList = it.map((e) => ParamModel.fromJSON(e)).toList();
    return paramList;
  }

  Future getTipe() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    final data = (json.decode(response.body) as Map<String, dynamic>)['data'];
    final String tipe = data[0]['tipe_benda'];
    return tipe;
  }
}

//READ LATEST INPUT PARAMETER M2
// class readLatestParamM2 {
//   Uri url = Uri.parse("https://berli.aplikasipms.com/api/latestParamM2");
//   Future getParamM2() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//         var getToken = shared.getString("token");
//     var hasilResponseGet = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it =
//         (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<ParamModel2> paramList =
//         it.map((e) => ParamModel2.fromJSON(e)).toList();
//     return paramList;
//   }
//     Future getTipe() async{
//      final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     var response = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     final data = (json.decode(response.body)as Map<String, dynamic>)['data'];
//     final String tipe = data[0]['tipe_benda'];
//     return tipe;
//   }
// }

// //READ LATEST INPUT PARAMETER M3
// class readLatestParamM3 {
//       Uri url = Uri.parse("https://berli.aplikasipms.com/api/latestParamM3");
//   Future getParamM3() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//         var getToken = shared.getString("token");
//     var hasilResponseGet = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it =
//         (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<ParamModel3> paramList =
//         it.map((e) => ParamModel3.fromJSON(e)).toList();
//     return paramList;
//   }
//     Future getTipe() async{
//      final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     var response = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     final data = (json.decode(response.body)as Map<String, dynamic>)['data'];
//     final String tipe = data[0]['tipe_benda'];
//     return tipe;
//   }
// }

// //READ LATEST INPUT PARAMETER M2
// class readLatestParamM4 {
//   Uri url = Uri.parse("https://berli.aplikasipms.com/api/latestParamM4");
//   Future getParamM4() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//         var getToken = shared.getString("token");

//     var hasilResponseGet = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     Iterable it =
//         (json.decode(hasilResponseGet.body) as Map<String, dynamic>)["data"];
//     List<ParamModel4> paramList =
//         it.map((e) => ParamModel4.fromJSON(e)).toList();
//     return paramList;
//   }
//   Future getTipe() async{
//      final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     var response = await http.get(url,headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     final data = (json.decode(response.body)as Map<String, dynamic>)['data'];
//     final String tipe = data[0]['tipe_benda'];
//     return tipe;
//   }
// }
