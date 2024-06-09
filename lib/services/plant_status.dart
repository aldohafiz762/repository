// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class PlantStatus {
//   Future statusPlant() async {
//     final SharedPreferences shared = await SharedPreferences.getInstance();
//     var getToken = shared.getString("token");
//     Uri url = Uri.parse("https://bismillah-lulus-ta.vercel.app/getStatus");
//     var response = await http.get(url, headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Basic $getToken'
//     });
//     var data = jsonDecode(response.body) as Map<String, dynamic>;
//     bool status = data['status'];
//     return status;
//   }
// }
