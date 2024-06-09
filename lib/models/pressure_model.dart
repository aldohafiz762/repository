class PressureGauge {
  late dynamic value;

  PressureGauge({this.value});

  factory PressureGauge.fromJSON(Map<String, dynamic> json) {
    return PressureGauge(value: json['value']);
  }
}

class PressurePoint {
  late final double x;
  late final double y;
  PressurePoint({required this.x, required this.y});
}

class PressureModel {
  late dynamic value;

  PressureModel({
    this.value,
  });

  factory PressureModel.fromJSON(Map<String, dynamic> json) {
    return PressureModel(
      value: json['value'],
    );
  }
}
