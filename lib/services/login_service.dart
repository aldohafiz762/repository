import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project_tugas_akhir_copy/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLASS Login User--------------------------------------------------------------------------
class LoginService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("https://bismillah-lulus-ta.vercel.app/api/login");

    var responseLogin = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    var data = json.decode(responseLogin.body)['data'];
    print(data);
    if (responseLogin.statusCode == 200) {
      // Shared
      final SharedPreferences sharedData =
          await SharedPreferences.getInstance();
      sharedData.setString("name", data['name']);
      sharedData.setString("otoritas", data['otoritas']);
      sharedData.setString("token", data['token']);
      return true;
    } else {
      return false;
    }
  }
}
