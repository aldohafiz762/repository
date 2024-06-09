class LifetimeModel {
  late int? machine_id, timevalue;

  LifetimeModel({this.machine_id, this.timevalue});

  factory LifetimeModel.fromJSON(Map<String, dynamic> json) {
    return LifetimeModel(
        machine_id: json['machine_id'], timevalue: json['timevalue']);
  }
}
