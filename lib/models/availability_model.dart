class AvaiModelM {
  late int? machine_id, state;
  late dynamic availabilityrate, operation, setup, breakdown;

  AvaiModelM(
      {this.machine_id,
      this.state,
      this.operation,
      this.setup,
      this.breakdown,
      this.availabilityrate});

  factory AvaiModelM.fromJSON(Map<String, dynamic> json) {
    return AvaiModelM(
      machine_id: json['machine_id'],
      operation: json['operation'],
      setup: json['setup'],
      breakdown: json['breakdown'],
      availabilityrate: json['availabilityrate'],
      state: json['state'],
    );
  }
  @override
  String toString() {
    return '{Machine_id: $machine_id, operation: $operation, setup: $setup, breakdown: $breakdown, availabilityrate: $availabilityrate, state: $state}';
  }
}
