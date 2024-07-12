import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_tugas_akhir_copy/models/energy_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Energy {
  final url = 'https://tugasakhirmangjody.my.id/api/sensGauge';

  Future getEnergy() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    try {
      var responseGetAll = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $getToken'
      });
      if (responseGetAll.statusCode == 200) {
        Iterable it =
            (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
        List<EnergyModel> energyList =
            it.map((e) => EnergyModel.fromJSON(e)).toList();
        return energyList;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class TableperEnergy {
  final url = 'https://tugasakhirmangjody.my.id/api/sensTable';

  //VOLTAGE
  Future getVolt() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<VoltModel> voltlist = it.map((e) => VoltModel.fromJSON(e)).toList();
      return voltlist;
    }
  }

  //CURRENT
  Future getCurrent() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<CurrentModel> currentlist =
          it.map((e) => CurrentModel.fromJSON(e)).toList();
      return currentlist;
    }
  }

  //POWER
  Future getPower() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PowerModel> powerlist =
          it.map((e) => PowerModel.fromJSON(e)).toList();
      return powerlist;
    }
  }

  //ENERGY
  Future getEnergi() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<EnergiModel> energilist =
          it.map((e) => EnergiModel.fromJSON(e)).toList();
      return energilist;
    }
  }

  //FREQUENCY
  Future getFrequency() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<FrequencyModel> frequencylist =
          it.map((e) => FrequencyModel.fromJSON(e)).toList();
      return frequencylist;
    }
  }

  //POWER FACTOR
  Future getPf() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PfModel> pflist = it.map((e) => PfModel.fromJSON(e)).toList();
      return pflist;
    }
  }

  //TEMPERATURE
  Future getTemp() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<TempModel> templist = it.map((e) => TempModel.fromJSON(e)).toList();
      return templist;
    }
  }

  //PRESSURE
  Future getPressure() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PressureModel> presslist =
          it.map((e) => PressureModel.fromJSON(e)).toList();
      return presslist;
    }
  }

  //STRAIN
  Future getStrain() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<StrainModel> strainlist =
          it.map((e) => StrainModel.fromJSON(e)).toList();
      return strainlist;
    }
  }

  //VIBRATION
  Future getVibration() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<VibrationModel> strainlist =
          it.map((e) => VibrationModel.fromJSON(e)).toList();
      return strainlist;
    }
  }
}

class ChartperEnergy {
  final url = 'https://tugasakhirmangjody.my.id/api/sensChart';

  //VOLTAGE
  Future getVolt() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<VoltModel> voltlist = it.map((e) => VoltModel.fromJSON(e)).toList();
      return voltlist;
    }
  }

  //CURRENT
  Future getCurrent() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<CurrentModel> currentlist =
          it.map((e) => CurrentModel.fromJSON(e)).toList();
      return currentlist;
    }
  }

  //POWER
  Future getPower() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PowerModel> powerlist =
          it.map((e) => PowerModel.fromJSON(e)).toList();
      return powerlist;
    }
  }

  //ENERGY
  Future getEnergi() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<EnergiModel> energilist =
          it.map((e) => EnergiModel.fromJSON(e)).toList();
      return energilist;
    }
  }

  //FREQUENCY
  Future getFrequency() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<FrequencyModel> frequencylist =
          it.map((e) => FrequencyModel.fromJSON(e)).toList();
      return frequencylist;
    }
  }

  //POWER FACTOR
  Future getPf() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PfModel> pflist = it.map((e) => PfModel.fromJSON(e)).toList();
      return pflist;
    }
  }

  //TEMPERATURE
  Future getTemp() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<TempModel> templist = it.map((e) => TempModel.fromJSON(e)).toList();
      return templist;
    }
  }

  //PRESSURE
  Future getPressure() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<PressureModel> presslist =
          it.map((e) => PressureModel.fromJSON(e)).toList();
      return presslist;
    }
  }

  //STRAIN
  Future getStrain() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<StrainModel> strainlist =
          it.map((e) => StrainModel.fromJSON(e)).toList();
      return strainlist;
    }
  }

  //VIBRATION
  Future getVibration() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    var getToken = shared.getString("token");
    var responseGetAll = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $getToken'
    });
    if (responseGetAll.statusCode == 200) {
      Iterable it =
          (json.decode(responseGetAll.body) as Map<String, dynamic>)["data"];
      List<VibrationModel> strainlist =
          it.map((e) => VibrationModel.fromJSON(e)).toList();
      return strainlist;
    }
  }
}
