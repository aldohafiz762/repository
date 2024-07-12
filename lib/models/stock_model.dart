class StockModel {
  late int? machine_id, stock, stockIn, stockOut;
  late String? updatedAt;

  StockModel(
      {this.machine_id,
      this.stock,
      this.updatedAt,
      this.stockIn,
      this.stockOut});

  factory StockModel.fromJSON(Map<String, dynamic> json) {
    return StockModel(
        machine_id: json["machine_id"],
        stock: json["stock"],
        stockIn: json["stockIn"],
        stockOut: json["stockOut"],
        // B: json["B"],
        // C: json["C"],
        updatedAt: json["updatedAt"]);
  }
  @override
  String toString() {
    return '{machine_id: $machine_id stock: $stock, stockIn: $stockIn, stockOut: $stockOut, updatedAt: $updatedAt}';
  }
}

//REPORT
class AllstockModel {
  late int? machine_id, A, B, C;
  late String? updatedAt;

  AllstockModel({this.machine_id, this.A, this.B, this.C, this.updatedAt});

  factory AllstockModel.fromJSON(Map<String, dynamic> json) {
    return AllstockModel(
        machine_id: json["machine_id"],
        A: json["A"],
        B: json["B"],
        C: json["C"],
        updatedAt: json["updatedAt"]);
  }
}

class Historimodel {
  late String? id, tipe, dibuat, createdAt;
  late int? jumlah, machine_id;

  Historimodel(
      {this.id,
      this.machine_id,
      this.dibuat,
      this.jumlah,
      this.tipe,
      this.createdAt});

  factory Historimodel.fromJSON(Map<String, dynamic> json) {
    return Historimodel(
        id: json["_id"],
        machine_id: json["machine_id"],
        tipe: json["tipe"],
        dibuat: json["dibuat"],
        jumlah: json["jumlah"],
        createdAt: json["createdAt"]);
  }
}
