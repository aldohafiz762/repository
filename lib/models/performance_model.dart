class GetPerformanceModel {
  late int? machine_id, state;
  late dynamic cycle,
      performancerate,
      processed,
      operation,
      speedAvg,
      stoppageAvg;

  GetPerformanceModel(
      {this.machine_id,
      this.cycle,
      this.operation,
      this.performancerate,
      this.processed,
      this.speedAvg,
      this.stoppageAvg,
      this.state});

  factory GetPerformanceModel.fromJSON(Map<String, dynamic> json) {
    return GetPerformanceModel(
        machine_id: json["machine_id"],
        processed: json["processed"],
        operation: json["operation"],
        cycle: json["cycle"],
        performancerate: json["performancerate"],
        speedAvg: json["speedAvg"],
        stoppageAvg: json["stoppageAvg"],
        state: json["state"]);
  }
  @override
  String toString() {
    return '{machine_id: $machine_id, processed: $processed, operation: $operation, cycle: $cycle, performancerate: $performancerate, speedAvg: $speedAvg, stoppageAvg: $stoppageAvg, state: $state}';
  }
}
