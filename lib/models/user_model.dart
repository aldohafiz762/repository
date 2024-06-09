class userModel{
  late String? username,password,name,otoritas,noHp,id;

  userModel({this.username,this.password,this.name,this.otoritas,this.noHp,this.id});

  factory userModel.fromJSON(Map<String,  dynamic> json){
    return userModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      name: json['name'],
      otoritas: json['otoritas'],
      noHp: json['noHp'],
    );
  }
}

class userMTModel{
  late String? name;

  userMTModel({this.name});

  factory userMTModel.fromJSON(Map<String,  dynamic> json){
    return userMTModel(
      name: json['name'],
    );
  }
}

