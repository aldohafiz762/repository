class DashBLModel {
  late int? machine_id, state;
  late dynamic setup, breakdown, stoppage, speed, startup, reject;
  late String? updatedAt, createdAt;

  DashBLModel(
      {this.machine_id,
      this.state,
      this.createdAt,
      this.setup,
      this.breakdown,
      this.stoppage,
      this.speed,
      this.startup,
      this.reject,
      this.updatedAt});

  factory DashBLModel.fromJSON(Map<String, dynamic> json) {
    return DashBLModel(
        machine_id: json['machine_id'],
        // tipe: json['tipe'],
        setup: json['setup'],
        breakdown: json['breakdown'],
        stoppage: json['stoppage'],
        speed: json['speed'],
        startup: json['startup_reject'],
        reject: json['reject'],
        updatedAt: json['updatedAt'],
        state: json['state'],
        createdAt: json['createdAt']);
  }
  @override
  String toString() {
    return '{machine_id: $machine_id, setup: $setup, breakdown: $breakdown, stoppage: $stoppage, speed: $speed, reject: $reject, startup_reject: $startup, updatedAt: $updatedAt, createdAt: $createdAt, state: $state}';
  }
}
