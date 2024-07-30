// ignore: depend_on_referenced_packages

class EnergyModel {
  late String? id, createdAt;
  late dynamic voltage,
      current,
      power,
      energy,
      frequency,
      pf,
      temperature,
      strain,
      vibration,
      pressure;

  EnergyModel(
      {this.voltage,
      this.current,
      this.power,
      this.energy,
      this.pf,
      this.frequency,
      this.temperature,
      this.pressure,
      this.strain,
      this.vibration,
      this.id,
      this.createdAt});

  factory EnergyModel.fromJSON(Map<String, dynamic> json) {
    return EnergyModel(
        id: json['_id'],
        voltage: json['voltage'],
        current: json['current'],
        power: json['power'],
        energy: json['energy'],
        frequency: json['frequency'],
        pf: json['pf'],
        temperature: json['temperature'],
        pressure: json['pressure'],
        strain: json['strain'],
        vibration: json['vibration'],
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'voltage': voltage,
      'current': current,
      'power': power,
      'energy': energy,
      'frequency': frequency,
      'pf': pf,
      'temperature': temperature,
      'pressure': pressure,
      'strain': strain,
      'vibration': vibration,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return '{id: $id, voltage: $voltage, current: $current, power: $power, energy: $energy, frequency: $frequency, pf: $pf, temperature: $temperature, pressure: $pressure, strain: $strain, vibration: $vibration, createdAt: $createdAt}';
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
  late String? createdAt;

  VoltModel({this.voltage, this.createdAt});

  factory VoltModel.fromJSON(Map<String, dynamic> json) {
    return VoltModel(voltage: json['voltage'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'voltage': voltage, 'createdAt': createdAt};
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
  late String? createdAt;

  CurrentModel({this.current, this.createdAt});

  factory CurrentModel.fromJSON(Map<String, dynamic> json) {
    return CurrentModel(current: json['current'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'current': current, 'createdAt': createdAt};
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
  late String? createdAt;

  PowerModel({this.power, this.createdAt});

  factory PowerModel.fromJSON(Map<String, dynamic> json) {
    return PowerModel(power: json['power'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'power': power, 'createdAt': createdAt};
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
  late String? createdAt;

  EnergiModel({this.energy, this.createdAt});

  factory EnergiModel.fromJSON(Map<String, dynamic> json) {
    return EnergiModel(energy: json['energy'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'energy': energy, 'createdAt': createdAt};
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
  late String? createdAt;

  FrequencyModel({this.frequency, this.createdAt});

  factory FrequencyModel.fromJSON(Map<String, dynamic> json) {
    return FrequencyModel(
        frequency: json['frequency'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'frequency': frequency, 'createdAt': createdAt};
  }
}

//TEMPERATURE
class TempPoint {
  late final double x;
  late final double y;
  TempPoint({required this.x, required this.y});
}

class TempModel {
  late dynamic temperature;
  late String? createdAt;

  TempModel({this.temperature, this.createdAt});

  factory TempModel.fromJSON(Map<String, dynamic> json) {
    return TempModel(
        temperature: json['temperature'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'temperature': temperature, 'createdAt': createdAt};
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
  late String? createdAt;

  PfModel({this.pf, this.createdAt});

  factory PfModel.fromJSON(Map<String, dynamic> json) {
    return PfModel(pf: json['pf'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'pf': pf, 'createdAt': createdAt};
  }
}

//PRESSURE
class PressurePoint {
  late final double x;
  late final double y;
  PressurePoint({required this.x, required this.y});
}

class PressureModel {
  late dynamic pressure;
  late String? createdAt;

  PressureModel({this.pressure, this.createdAt});

  factory PressureModel.fromJSON(Map<String, dynamic> json) {
    return PressureModel(
        pressure: json['pressure'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'pressure': pressure, 'createdAt': createdAt};
  }
}

//STRAIN
class StrainPoint {
  late final double x;
  late final double y;
  StrainPoint({required this.x, required this.y});
}

class StrainModel {
  late dynamic strain;
  late String? createdAt;

  StrainModel({this.strain, this.createdAt});

  factory StrainModel.fromJSON(Map<String, dynamic> json) {
    return StrainModel(strain: json['strain'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'strain': strain, 'createdAt': createdAt};
  }
}

//VIBRATION
class VibrationPoint {
  late final double x;
  late final double y;
  VibrationPoint({required this.x, required this.y});
}

class VibrationModel {
  late dynamic vibration;
  late String? createdAt;

  VibrationModel({this.vibration, this.createdAt});

  factory VibrationModel.fromJSON(Map<String, dynamic> json) {
    return VibrationModel(
        vibration: json['vibration'], createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJSON() {
    return {'vibration': vibration, 'createdAt': createdAt};
  }
}
