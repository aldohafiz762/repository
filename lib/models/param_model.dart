class ParamModel {
  late int? machine_id, oee_target, harga_perUnit, state;
  late dynamic cycle_time, loading_time;
  late String? tipe_benda, id;

  ParamModel(
      {this.machine_id,
      this.loading_time,
      this.cycle_time,
      this.oee_target,
      this.harga_perUnit,
      this.state,
      this.tipe_benda,
      this.id});

  factory ParamModel.fromJSON(Map<String, dynamic> json) {
    return ParamModel(
      machine_id: json['machine_id'],
      loading_time: json['loading_time'],
      cycle_time: json['cycle_time'],
      oee_target: json['oee_target'],
      harga_perUnit: json['harga_perUnit'],
      tipe_benda: json['tipe_benda'],
      state: json['state'],
      id: json['_id'],
    );
  }
}

// class ParamModel2{
//   late  int? machine_id,oee_target,harga_perUnit,state;
//   late dynamic loading_time, cycle_time;
//   late String? tipe_benda,id;

//   ParamModel2({this.machine_id, this.loading_time, this.cycle_time, this.oee_target, this.harga_perUnit, this.tipe_benda,this.id,this.state});

//   factory ParamModel2.fromJSON(Map<String, dynamic> json){
//       return ParamModel2(
//         machine_id: json['machine_id'],
//         loading_time: json['loading_time'],
//         cycle_time: json['cycle_time'],
//         oee_target: json['oee_target'],
//         harga_perUnit: json['harga_perUnit'],
//         tipe_benda: json['tipe_benda'],
//         state:json['state'],
//         id: json['_id'],
//       );
//   }
// }

// class ParamModel3{
//   late  int? machine_id,oee_target,harga_perUnit,state;
//   late dynamic loading_time, cycle_time;
//   late String? tipe_benda,id;

//   ParamModel3({this.machine_id, this.loading_time, this.cycle_time, this.oee_target, this.harga_perUnit, this.tipe_benda,this.id,this.state});

//   factory ParamModel3.fromJSON(Map<String, dynamic> json){
//       return ParamModel3(
//         machine_id: json['machine_id'],
//         loading_time: json['loading_time'],
//         cycle_time: json['cycle_time'],
//         oee_target: json['oee_target'],
//         harga_perUnit: json['harga_perUnit'],
//         tipe_benda: json['tipe_benda'],
//         state:json['state'],
//         id: json['_id'],
//       );
//   }
// }

// class ParamModel4{
//   late  int? machine_id,oee_target,harga_perUnit,state;
//   late dynamic loading_time, cycle_time;
//   late String? tipe_benda,id;

//   ParamModel4({this.machine_id, this.loading_time, this.cycle_time, this.oee_target, this.harga_perUnit, this.tipe_benda,this.id,this.state});

//   factory ParamModel4.fromJSON(Map<String, dynamic> json){
//       return ParamModel4(
//         machine_id: json['machine_id'],
//         loading_time: json['loading_time'],
//         cycle_time: json['cycle_time'],
//         oee_target: json['oee_target'],
//         harga_perUnit: json['harga_perUnit'],
//         tipe_benda: json['tipe_benda'],
//         state:json['state'],
//         id: json['_id'],
//       );
//   }
// }

class ParamReportModel {
  late int? machine_id, oee_target;
  late dynamic cycle_time, loading_time;
  late String? tipe_benda, updatedAt;

  ParamReportModel(
      {this.machine_id,
      this.loading_time,
      this.cycle_time,
      this.oee_target,
      this.updatedAt,
      this.tipe_benda});

  factory ParamReportModel.fromJSON(Map<String, dynamic> json) {
    return ParamReportModel(
        machine_id: json['machine_id'],
        loading_time: json['loading_time'],
        cycle_time: json['cycle_time'],
        oee_target: json['oee_target'],
        tipe_benda: json['tipe_benda'],
        updatedAt: json['updatedAt']);
  }
}
