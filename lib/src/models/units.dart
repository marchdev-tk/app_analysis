// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:app_analysis/app_analysis.dart';

abstract class AnalysisUnitsInterface implements Encodable {
  const AnalysisUnitsInterface._();

  String get batteryLevel;
  String get batteryTemperature;

  String get cpuFrequency;
  String get cpuUsagePercents;
  String get cpuTemperature;

  MemVolUnit get ramConsumption;
  String get ramConsumptionPercents;

  MemVolUnit get trafficConsumption;
}

class AnalysisUnits implements AnalysisUnitsInterface {
  const AnalysisUnits({
    required this.batteryLevel,
    required this.batteryTemperature,
    required this.cpuFrequency,
    required this.cpuTemperature,
  });

  factory AnalysisUnits.fromMap(Map<String, dynamic> map) {
    return AnalysisUnits(
      batteryLevel: map['batteryLevel'],
      batteryTemperature: map['batteryTemperature'],
      cpuFrequency: map['cpuFrequency'],
      cpuTemperature: map['cpuTemperature'],
    );
  }

  @override
  final String batteryLevel;
  @override
  final String batteryTemperature;

  @override
  final String cpuFrequency;
  @override
  String get cpuUsagePercents => '%';
  @override
  final String cpuTemperature;

  @override
  MemVolUnit get ramConsumption => MemVolUnit();
  @override
  String get ramConsumptionPercents => '%';

  @override
  MemVolUnit get trafficConsumption => MemVolUnit();

  @override
  Map<String, dynamic> toMap({bool full = false}) {
    return {
      'batteryLevel': batteryLevel,
      'batteryTemperature': batteryTemperature,
      'cpuFrequency': cpuFrequency,
      'cpuTemperature': cpuTemperature,
      if (full) ...{
        'cpuUsagePercents': cpuUsagePercents,
        'ramConsumption': ramConsumption.toString(),
        'ramConsumptionPercents': ramConsumptionPercents,
        'trafficConsumption': trafficConsumption.toString(),
      },
    };
  }

  @override
  String toString() => json.encode(toMap());

  @override
  int get hashCode =>
      batteryLevel.hashCode ^
      batteryTemperature.hashCode ^
      cpuFrequency.hashCode ^
      cpuTemperature.hashCode;

  @override
  bool operator ==(covariant AnalysisUnits other) =>
      batteryLevel == other.batteryLevel &&
      batteryTemperature == other.batteryTemperature &&
      cpuFrequency == other.cpuFrequency &&
      cpuTemperature == other.cpuTemperature;
}
