class AvaiModelM {
  late int? machine_id, state, operationtime, downtime, runningtime;
  late dynamic availabilityrate;

  AvaiModelM(
      {this.machine_id,
      this.state,
      this.operationtime,
      this.downtime,
      this.runningtime,
      this.availabilityrate});

  factory AvaiModelM.fromJSON(Map<String, dynamic> json) {
    return AvaiModelM(
      machine_id: json['machine_id'],
      operationtime: json['operationtime'],
      downtime: json['downtime'],
      runningtime: json['runningtime'],
      availabilityrate: json['availabilityrate'],
      state: json['state'],
    );
  }
}
