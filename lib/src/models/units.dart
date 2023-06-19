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
  String get cpuTemperature;

  String get ramConsumption;

  String get trafficConsumption;
}

class AnalysisUnits implements AnalysisUnitsInterface {
  const AnalysisUnits({
    required this.batteryLevel,
    required this.batteryTemperature,
    required this.cpuFrequency,
    required this.cpuTemperature,
    required this.ramConsumption,
    required this.trafficConsumption,
  });

  factory AnalysisUnits.fromMap(Map<String, dynamic> map) {
    return AnalysisUnits(
      batteryLevel: map['batteryLevel'],
      batteryTemperature: map['batteryTemperature'],
      cpuFrequency: map['cpuFrequency'],
      cpuTemperature: map['cpuTemperature'],
      ramConsumption: map['ramConsumption'],
      trafficConsumption: map['trafficConsumption'],
    );
  }

  @override
  final String batteryLevel;
  @override
  final String batteryTemperature;

  @override
  final String cpuFrequency;
  @override
  final String cpuTemperature;

  @override
  final String ramConsumption;

  @override
  final String trafficConsumption;

  @override
  Map<String, dynamic> toMap() {
    return {
      'batteryLevel': batteryLevel,
      'batteryTemperature': batteryTemperature,
      'cpuFrequency': cpuFrequency,
      'cpuTemperature': cpuTemperature,
      'ramConsumption': ramConsumption,
      'trafficConsumption': trafficConsumption,
    };
  }

  @override
  String toString() => json.encode(toMap());
}
