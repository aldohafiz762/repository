import 'dart:async';
// import 'package:flutter/material.dart';

class DashStatusModel {
  late int? status;
  late String? id;
  DashStatusModel({this.status, this.id});

  factory DashStatusModel.fromJSON(Map<String, dynamic> json) {
    return DashStatusModel(
        id: json['_id'],
        // machine_id: json["machine_id"],
        // status: json["status"],
        status: json['status']);
  }
}

class DataProvider {
  final StreamController<List<DashStatusModel>> _controller =
      StreamController.broadcast();

  Stream<List<DashStatusModel>> get stream => _controller.stream;

  void addData(List<DashStatusModel> data) {
    _controller.sink.add(data);
  }

  void dispose() {
    _controller.close();
  }
}

class Status1Model {
  // late int? machine_id;
  late int? status;

  Status1Model({this.status});

  factory Status1Model.fromJSON(Map<String, dynamic> json) {
    return Status1Model(
      // machine_id: json["machine_id"],
      status: json["status"],
    );
  }
}
// class status2Model{
//   late int? machine_id, status;

//   status2Model({this.machine_id,this.status});

//   factory status2Model.fromJSON(Map<String, dynamic> json){
//     return status2Model(
//       machine_id: json["machine_id"],
//       status: json["status"],
//     );
//   }
// }
// class status3Model{
//   late int? machine_id, status;

//   status3Model({this.machine_id,this.status});

//   factory status3Model.fromJSON(Map<String, dynamic> json){
//     return status3Model(
//       machine_id: json["machine_id"],
//       status: json["status"],
//     );
//   }
// }
// class status4Model{
//   late int? machine_id, status;

//   status4Model({this.machine_id,this.status});

//   factory status4Model.fromJSON(Map<String, dynamic> json){
//     return status4Model(
//       machine_id: json["machine_id"],
//       status: json["status"],
//     );
//   }
// }