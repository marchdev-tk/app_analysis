// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:app_analysis/app_analysis.dart';

abstract class AnalysisDataInterface implements Encodable {
  const AnalysisDataInterface._();

  Map<DateTime, num> get batteryLevel;
  Map<DateTime, num> get batteryTemperature;

  Map<DateTime, List<num>> get cpuFrequency;
  Map<DateTime, List<num>> getCpuUsagePercents(Extremum<List<num>> extremum);
  Map<DateTime, num> get cpuTemperature;

  Map<DateTime, RamInfo> get ramConsumption;
  Map<DateTime, num> get ramConsumptionPercents;

  Map<DateTime, MemUnit> get trafficConsumption;
  Map<DateTime, MemUnit> get trafficConsumptionCumulative;
}

class AnalysisData implements AnalysisDataInterface {
  const AnalysisData({
    required this.batteryLevel,
    required this.batteryTemperature,
    required this.cpuFrequency,
    required this.cpuTemperature,
    required this.ramConsumption,
    required this.trafficConsumption,
  });

  factory AnalysisData.fromMap(Map<String, dynamic> map) {
    return AnalysisData(
      batteryLevel: _parseMap(map['batteryLevel']),
      batteryTemperature: _parseMap(map['batteryTemperature']),
      cpuFrequency: Map<String, List<dynamic>>.from(map['cpuFrequency']).map(
        (key, value) => MapEntry(DateTime.parse(key), List<num>.from(value)),
      ),
      cpuTemperature: _parseMap(map['cpuTemperature']),
      ramConsumption:
          Map<String, Map<String, dynamic>>.from(map['ramConsumption']).map(
        (key, value) => MapEntry(DateTime.parse(key), RamInfo.fromMap(value)),
      ),
      trafficConsumption: Map<String, int>.from(map['trafficConsumption'])
          .map((key, value) => MapEntry(DateTime.parse(key), MemUnit(value))),
    );
  }

  static Map<DateTime, num> _parseMap(dynamic map) => Map<String, num>.from(map)
      .map((key, value) => MapEntry(DateTime.parse(key), value));
  static Map<String, num> _toMap(Map<DateTime, num> map) =>
      map.map((key, value) => MapEntry(key.toIso8601String(), value));

  static const empty = AnalysisData(
    batteryLevel: {},
    batteryTemperature: {},
    cpuFrequency: {},
    cpuTemperature: {},
    ramConsumption: {},
    trafficConsumption: {},
  );

  @override
  final Map<DateTime, num> batteryLevel;
  @override
  final Map<DateTime, num> batteryTemperature;

  @override
  final Map<DateTime, List<num>> cpuFrequency;
  @override
  Map<DateTime, List<num>> getCpuUsagePercents(Extremum<List<num>> extremum) {
    return cpuFrequency.map(
      (key, value) {
        var percents = <num>[];

        for (var i = 0; i < value.length; i++) {
          final biasedValue = value[i] - extremum.min[i];
          final extremumRange = extremum.max[i] - extremum.min[i];
          percents.add(biasedValue / extremumRange * 100);
        }

        return MapEntry(key, percents);
      },
    );
  }

  @override
  final Map<DateTime, num> cpuTemperature;

  @override
  final Map<DateTime, RamInfo> ramConsumption;
  @override
  Map<DateTime, num> get ramConsumptionPercents => ramConsumption
      .map((key, value) => MapEntry(key, value.percentUsed * 100));

  @override
  final Map<DateTime, MemUnit> trafficConsumption;
  @override
  Map<DateTime, MemUnit> get trafficConsumptionCumulative {
    final cumulativeData = <DateTime, MemUnit>{};

    var sum = const MemUnit(0);
    for (var key in trafficConsumption.keys) {
      cumulativeData[key] = sum + trafficConsumption[key]!;
      sum = cumulativeData[key]!;
    }

    return cumulativeData;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'batteryLevel': _toMap(batteryLevel),
      'batteryTemperature': _toMap(batteryTemperature),
      'cpuFrequency': cpuFrequency
          .map((key, value) => MapEntry(key.toIso8601String(), value)),
      'cpuTemperature': _toMap(cpuTemperature),
      'ramConsumption': ramConsumption
          .map((key, value) => MapEntry(key.toIso8601String(), value.toMap())),
      'trafficConsumption': trafficConsumption
          .map((key, value) => MapEntry(key.toIso8601String(), value.bytes)),
    };
  }

  @override
  String toString() => json.encode(toMap());

  @override
  int get hashCode =>
      MdHash.map(batteryLevel) ^
      MdHash.map(batteryTemperature) ^
      MdHash.map(cpuFrequency) ^
      MdHash.map(cpuTemperature) ^
      MdHash.map(ramConsumption) ^
      MdHash.map(trafficConsumption);

  @override
  bool operator ==(covariant AnalysisData other) =>
      MdEquals.map(batteryLevel, other.batteryLevel) &&
      MdEquals.map(batteryTemperature, other.batteryTemperature) &&
      MdEquals.map(cpuFrequency, other.cpuFrequency) &&
      MdEquals.map(cpuTemperature, other.cpuTemperature) &&
      MdEquals.map(ramConsumption, other.ramConsumption) &&
      MdEquals.map(trafficConsumption, other.trafficConsumption);
}
