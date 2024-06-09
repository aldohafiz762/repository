class GetPerformanceModel {
  late int? machine_id, state, processed, operationtime;
  late dynamic cycle_time, performancerate;

  GetPerformanceModel(
      {this.machine_id,
      this.cycle_time,
      this.operationtime,
      this.performancerate,
      this.processed,
      this.state});

  factory GetPerformanceModel.fromJSON(Map<String, dynamic> json) {
    return GetPerformanceModel(
        machine_id: json["machine_id"],
        processed: json["processed"],
        operationtime: json["operationtime"],
        cycle_time: json["cycle_time"],
        performancerate: json["performancerate"],
        state: json["state"]);
  }
}
