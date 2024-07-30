class GetOEEModel {
  late String? tanggal;
  late int? machine_id, state;
  late dynamic quality, availability, performance, nilaioee;

  GetOEEModel(
      {this.availability,
      this.machine_id,
      this.nilaioee,
      this.performance,
      this.quality,
      this.state,
      this.tanggal});

  factory GetOEEModel.FromJSON(Map<String, dynamic> json) {
    return GetOEEModel(
        tanggal: json['tanggal'],
        machine_id: json['machine_id'],
        quality: json['quality'],
        availability: json['availability'],
        performance: json['performance'],
        nilaioee: json['nilaioee'],
        state: json['state']);
  }
}

class OEEdashModel {
  late String? tanggal, updatedAt, createdAt;
  late int? machine_id, state;
  late dynamic quality, availability, performance, nilaioee;

  OEEdashModel({
    this.availability,
    this.machine_id,
    this.nilaioee,
    this.performance,
    this.quality,
    this.state,
    this.tanggal,
    this.updatedAt,
    this.createdAt,
  });

  factory OEEdashModel.FromJSON(Map<String, dynamic> json) {
    return OEEdashModel(
        tanggal: json['tanggal'],
        machine_id: json['machine_id'],
        quality: json['quality'],
        availability: json['availability'],
        performance: json['performance'],
        nilaioee: json['nilaioee'],
        state: json['state'],
        updatedAt: json['updatedAt'],
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'machine_id': machine_id,
      'quality': quality,
      'availability': availability,
      'performance': performance,
      'nilaioee': nilaioee,
      'state': state,
      'updatedAt': updatedAt,
      'createdAt': createdAt
    };
  }

  @override
  String toString() {
    return '{tanggal: $tanggal, machine_id: $machine_id, quality: $quality, availability: $availability, performance: $performance, nilaioee: $nilaioee, updatedAt: $updatedAt}';
  }
}

class OEEHistoriModel {
  late String? tanggal, updatedAt;
  late int? machine_id;
  late dynamic quality, availability, performance, nilaioee;

  OEEHistoriModel(
      {this.availability,
      this.machine_id,
      this.nilaioee,
      this.performance,
      this.quality,
      this.tanggal,
      this.updatedAt});

  factory OEEHistoriModel.FromJSON(Map<String, dynamic> json) {
    return OEEHistoriModel(
        tanggal: json['tanggal'],
        machine_id: json['machine_id'],
        quality: json['quality'],
        availability: json['availability'],
        performance: json['performance'],
        nilaioee: json['nilaioee'],
        updatedAt: json['updatedAt']);
  }
}
