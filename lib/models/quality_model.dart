class CurrentQuality {
  late int? machine_id, state, good, defect, processed;
  late String? tipe;
  late dynamic qualityrate;

  CurrentQuality(
      {this.machine_id,
      this.state,
      this.good,
      this.defect,
      this.processed,
      this.qualityrate,
      this.tipe});

  factory CurrentQuality.fromJSON(Map<String, dynamic> json) {
    return CurrentQuality(
      machine_id: json['machine_id'],
      tipe: json['tipe'],
      good: json['good'],
      defect: json['defect'],
      processed: json['processed'],
      qualityrate: json['qualityrate'],
      state: json['state'],
    );
  }
}

class DashQuality {
  late int? machine_id, state, good, defect, processed;
  late String? updatedAt;

  DashQuality(
      {this.machine_id,
      this.state,
      this.good,
      this.defect,
      this.processed,
      // this.tipe,
      this.updatedAt});

  factory DashQuality.fromJSON(Map<String, dynamic> json) {
    return DashQuality(
      machine_id: json['machine_id'],
      // tipe: json['tipe'],
      good: json['good'],
      defect: json['defect'],
      processed: json['processed'],
      updatedAt: json['updatedAt'],
      state: json['state'],
    );
  }
}

class RecQuality {
  late int? machine_id, state, processed, good, defect;
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
