// ignore: depend_on_referenced_packages

class EnergyModel {
  late String? id;
  late dynamic voltage, current, power, energy, frequency, pf;

  EnergyModel(
      {this.voltage,
      this.current,
      this.power,
      this.energy,
      this.pf,
      this.frequency,
      this.id});

  factory EnergyModel.fromJSON(Map<String, dynamic> json) {
    return EnergyModel(
        id: json['_id'],
        voltage: json['voltage'],
        current: json['current'],
        power: json['power'],
        energy: json['energy'],
        frequency: json['frequency'],
        pf: json['pf']);
  }
}

//CHART ENERGY USAGE
//VOLTAGE
class VoltPoint {
  late final double x;
  late final double y;
  VoltPoint({required this.x, required this.y});
}

class VoltModel {
  late dynamic voltage;

  VoltModel({
    this.voltage,
  });

  factory VoltModel.fromJSON(Map<String, dynamic> json) {
    return VoltModel(
      voltage: json['voltage'],
    );
  }
}

//CURRENT
class CurrentPoint {
  late final double x;
  late final double y;
  CurrentPoint({required this.x, required this.y});
}

class CurrentModel {
  late dynamic current;

  CurrentModel({
    this.current,
  });

  factory CurrentModel.fromJSON(Map<String, dynamic> json) {
    return CurrentModel(
      current: json['current'],
    );
  }
}

//POWER
class PowerPoint {
  late final double x;
  late final double y;
  PowerPoint({required this.x, required this.y});
}

class PowerModel {
  late dynamic power;

  PowerModel({
    this.power,
  });

  factory PowerModel.fromJSON(Map<String, dynamic> json) {
    return PowerModel(
      power: json['power'],
    );
  }
}

//ENERGY
class EnergyPoint {
  late final double x;
  late final double y;
  EnergyPoint({required this.x, required this.y});
}

class EnergiModel {
  late double? energy;

  EnergiModel({
    this.energy,
  });

  factory EnergiModel.fromJSON(Map<String, dynamic> json) {
    return EnergiModel(
      energy: json['energy'],
    );
  }
}

//FREQUENCY
class FrequencyPoint {
  late final double x;
  late final double y;
  FrequencyPoint({required this.x, required this.y});
}

class FrequencyModel {
  late dynamic frequency;

  FrequencyModel({
    this.frequency,
  });

  factory FrequencyModel.fromJSON(Map<String, dynamic> json) {
    return FrequencyModel(
      frequency: json['frequency'],
    );
  }
}

//POWER FACTOR
class PfPoint {
  late final double x;
  late final double y;
  PfPoint({required this.x, required this.y});
}

class PfModel {
  late dynamic pf;

  PfModel({
    this.pf,
  });

  factory PfModel.fromJSON(Map<String, dynamic> json) {
    return PfModel(
      pf: json['pf'],
    );
  }
}
