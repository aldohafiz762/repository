import 'dart:ui';
import 'dart:core';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Maintenance {
  Maintenance(this.date, this.subject, this.color, this.isAllDay);

  DateTime date;
  String subject;
  Color color;
  bool isAllDay;
}

class MaintenanceDataSource extends CalendarDataSource {
  MaintenanceDataSource(List<Maintenance> getDataSource) {
    appointments = <Maintenance>[];
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date.add(Duration(hours: 2));
  }

  @override
  String getSubject(int index) {
    return appointments![index].subject;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class PreventiveMessageModel {
  late String? message, keterangan, createdAt, updatedAt;
  late int? machine_id, idpreventive;
  late bool? solved;

  PreventiveMessageModel(
      {this.machine_id,
      this.message,
      this.keterangan,
      this.solved,
      this.createdAt,
      this.updatedAt,
      this.idpreventive});

  factory PreventiveMessageModel.fromJSON(Map<String, dynamic> json) {
    return PreventiveMessageModel(
        machine_id: json['machine_id'],
        idpreventive: json['idpreventive'],
        message: json['message'],
        keterangan: json['keterangan'],
        solved: json['solved'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
  @override
  String toString() {
    return '{machine_id: $machine_id,\n idpreventive: $idpreventive,\n message: $message,\n keterangan: $keterangan,\n solved: $solved,\n updatedAt: $updatedAt,\n createdAt: $createdAt}';
  }
}

class PreventiveScheduleModel {
  late String? jam, menit, hari;
  late int? machine_id;

  PreventiveScheduleModel({this.machine_id, this.hari, this.jam, this.menit});

  factory PreventiveScheduleModel.fromJSON(Map<String, dynamic> json) {
    return PreventiveScheduleModel(
        machine_id: json['machine_id'],
        hari: json['hari'],
        jam: json['jam'],
        menit: json['menit']);
  }
}
