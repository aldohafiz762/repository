class GetPriceModel {
  late String? tipe, Nbaku1, Nbaku2, Nbaku3;
  late int? Pbaku1, Pbaku2, Pbaku3, Ptotal;

  GetPriceModel(
      {this.tipe,
      this.Nbaku1,
      this.Nbaku2,
      this.Nbaku3,
      this.Pbaku1,
      this.Pbaku2,
      this.Pbaku3,
      this.Ptotal});

  factory GetPriceModel.FromJSON(Map<String, dynamic> json) {
    return GetPriceModel(
        tipe: json['tipe'],
        Nbaku1: json['name_baku1'],
        Nbaku2: json['name_baku2'],
        Nbaku3: json['name_baku3'],
        Pbaku1: json['price_baku1'],
        Pbaku2: json['price_baku2'],
        Pbaku3: json['price_baku3'],
        Ptotal: json['price_total']);
  }
}

class GetCostModel {
  late int? machine_id, good, harga_unit, state, tarif_kwh, manpower;
  late dynamic daya, waktu, total_harga;
  late String? tipe, tanggal;

  GetCostModel(
      {this.machine_id,
      this.good,
      this.harga_unit,
      this.state,
      this.tanggal,
      this.tipe,
      this.total_harga,
      this.daya,
      this.manpower,
      this.tarif_kwh,
      this.waktu});

  factory GetCostModel.FromJSON(Map<String, dynamic> json) {
    return GetCostModel(
        machine_id: json['machine_id'],
        good: json['good'],
        harga_unit: json['harga_unit'],
        total_harga: json['total_harga'],
        tanggal: json['tanggal'],
        tipe: json['tipe'],
        state: json['state'],
        daya: json['daya'],
        manpower: json['manpower'],
        tarif_kwh: json['tarif_kwh'],
        waktu: json['waktu']);
  }
}

class GetCostHModel {
  late int? machine_id, good, harga_unit, state, tarif_kwh, manpower;
  late dynamic daya, waktu, total_harga;
  late String? tanggal, createdAt, updatedAt;

  GetCostHModel(
      {this.machine_id,
      this.good,
      this.harga_unit,
      this.state,
      this.tanggal,
      // this.tipe,
      this.total_harga,
      this.daya,
      this.manpower,
      this.tarif_kwh,
      this.waktu,
      this.createdAt,
      this.updatedAt});

  factory GetCostHModel.FromJSON(Map<String, dynamic> json) {
    return GetCostHModel(
        machine_id: json['machine_id'],
        good: json['good'],
        harga_unit: json['harga_unit'],
        total_harga: json['total_harga'],
        tanggal: json['tanggal'],
        // tipe: json['tipe'],
        state: json['state'],
        daya: json['daya'],
        manpower: json['manpower'],
        tarif_kwh: json['tarif_kwh'],
        waktu: json['waktu'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'machine_id': machine_id,
      'good': good,
      'harga_unit': harga_unit,
      'total_harga': total_harga,
      'tanggal': tanggal,
      // 'tipe': tipe,
      'state': state,
      'daya': daya,
      'manpower': manpower,
      'tarif_kwh': tarif_kwh,
      'waktu': waktu,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

class GetCostdashModel {
  late int? machine_id, good, total_harga, harga_unit;
  late String? tipe, updatedAt;

  GetCostdashModel(
      {this.machine_id,
      this.good,
      this.harga_unit,
      this.updatedAt,
      this.tipe,
      this.total_harga});

  factory GetCostdashModel.FromJSON(Map<String, dynamic> json) {
    return GetCostdashModel(
      machine_id: json['machine_id'],
      good: json['good'],
      harga_unit: json['harga_unit'],
      total_harga: json['total_harga'],
      updatedAt: json['updatedAt'],
      tipe: json['tipe'],
    );
  }
}
