// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class LoginRequestModel {
  late String? username, password;
  LoginRequestModel({this.username, this.password});

  LoginRequestModel.fromJSON(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
