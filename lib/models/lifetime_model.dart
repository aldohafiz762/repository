class LifetimeModel {
  late int? komponen_id;
  late dynamic timevalue;
  late String? name;

  LifetimeModel({this.komponen_id, this.timevalue, this.name});

  factory LifetimeModel.fromJSON(Map<String, dynamic> json) {
    return LifetimeModel(
        komponen_id: json['komponen_id'],
        name: json['name'],
        timevalue: json['timevalue']);
  }
  @override
  String toString() {
    return '{komponen_id: $komponen_id, name: $name, timevalue: $timevalue}';
  }
}
