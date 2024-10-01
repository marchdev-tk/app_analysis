// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:app_analysis/app_analysis.dart';

abstract class AnalysisExtremumsInterface implements Encodable {
  const AnalysisExtremumsInterface._();

  Extremum<num> get batteryLevel;
  Extremum<num> get batteryTemperature;

  Extremum<List<num>> get cpuFrequency;
  Extremum<num> get cpuTemperature;

  Extremum<MemUnit> get ramConsumption;
}

class AnalysisExtremums implements AnalysisExtremumsInterface {
  const AnalysisExtremums({
    required this.batteryLevel,
    required this.batteryTemperature,
    required this.cpuFrequency,
    required this.cpuTemperature,
    required this.ramConsumption,
  });

  factory AnalysisExtremums.fromMap(Map<String, dynamic> map) {
    return AnalysisExtremums(
      batteryLevel: Extremum<num>.fromMap(map['batteryLevel']),
      batteryTemperature: Extremum<num>.fromMap(map['batteryTemperature']),
      cpuFrequency: Extremum<List<num>>.fromMap(
        map['cpuFrequency'],
        (value) => List<num>.from(value),
      ),
      cpuTemperature: Extremum<num>.fromMap(map['cpuTemperature']),
      ramConsumption: Extremum<MemUnit>.fromMap(
        map['ramConsumption'],
        (value) => MemUnit(value),
      ),
    );
  }

  @override
  final Extremum<num> batteryLevel;
  @override
  final Extremum<num> batteryTemperature;

  @override
  final Extremum<List<num>> cpuFrequency;
  @override
  final Extremum<num> cpuTemperature;

  @override
  final Extremum<MemUnit> ramConsumption;

  @override
  Map<String, dynamic> toMap() {
    return {
      'batteryLevel': batteryLevel.toMap(),
      'batteryTemperature': batteryTemperature.toMap(),
      'cpuFrequency': cpuFrequency.toMap((value) => value),
      'cpuTemperature': cpuTemperature.toMap(),
      'ramConsumption': ramConsumption.toMap((value) => value.bytes),
    };
  }

  @override
  String toString() => json.encode(toMap());

  @override
  int get hashCode =>
      batteryLevel.hashCode ^
      batteryTemperature.hashCode ^
      cpuFrequency.hashCode ^
      cpuTemperature.hashCode ^
      ramConsumption.hashCode;

  @override
  bool operator ==(covariant AnalysisExtremums other) =>
      batteryLevel == other.batteryLevel &&
      batteryTemperature == other.batteryTemperature &&
      cpuFrequency == other.cpuFrequency &&
      cpuTemperature == other.cpuTemperature &&
      ramConsumption == other.ramConsumption;
}
