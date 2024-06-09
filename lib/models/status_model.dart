class DashStatusModel {
  late int? status;
  // late String? id;
  DashStatusModel({this.status});

  factory DashStatusModel.fromJSON(Map<String, dynamic> json) {
    return DashStatusModel(
        // id: json['_id'],
        // machine_id: json["machine_id"],
        // status: json["status"],
        status: json['status']);
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