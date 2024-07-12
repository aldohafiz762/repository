class CurrentQuality {
  late int? machine_id, state;
  // late String? tipe;
  late dynamic qualityrate, good, defect, processed;

  CurrentQuality({
    this.machine_id,
    this.state,
    this.good,
    this.defect,
    this.processed,
    this.qualityrate,
  });

  factory CurrentQuality.fromJSON(Map<String, dynamic> json) {
    return CurrentQuality(
      machine_id: json['machine_id'],
      // tipe: json['tipe'],
      good: json['good'],
      defect: json['defect'],
      processed: json['processed'],
      qualityrate: json['qualityrate'],
      state: json['state'],
    );
  }
  String toString() {
    return '{machine_id: $machine_id, good: $good, defect: $defect, processed: $processed, qualityrate: $qualityrate, state: $state}';
  }
}

class DashQuality {
  late int? machine_id, state;
  late dynamic good, defect, processed, qualityrate;
  late String? updatedAt, createdAt;

  DashQuality(
      {this.machine_id,
      this.state,
      this.good,
      this.defect,
      this.processed,
      this.qualityrate,
      this.createdAt,
      this.updatedAt});

  factory DashQuality.fromJSON(Map<String, dynamic> json) {
    return DashQuality(
      machine_id: json['machine_id'],
      // tipe: json['tipe'],
      good: json['good'],
      defect: json['defect'],
      processed: json['processed'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      qualityrate: json['qualityrate'],
      state: json['state'],
    );
  }
  @override
  String toString() {
    return '{machine_id: $machine_id, good: $good, defect: $defect, processed: $processed, qualityrate: $qualityrate, updatedAt: $updatedAt, state: $state, createdAt: $createdAt}';
  }
}

class RecQuality {
  late int? machine_id, state;
  late dynamic processed, good, defect;
  late String? tipe, createdAt;

  RecQuality(
      {this.machine_id,
      this.state,
      this.processed,
      this.tipe,
      this.createdAt,
      this.defect,
      this.good});

  factory RecQuality.fromJSON(Map<String, dynamic> json) {
    return RecQuality(
      machine_id: json['machine_id'],
      tipe: json['tipe'],
      good: json['good'],
      defect: json['defect'],
      processed: json['processed'],
      createdAt: json['createdAt'],
      state: json['state'],
    );
  }
}
