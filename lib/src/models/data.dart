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
  Map<DateTime, num> get cpuTemperature;

  Map<DateTime, RamInfo> get ramConsumption;

  Map<DateTime, num> get trafficConsumption;
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
      trafficConsumption: _parseMap(map['trafficConsumption']),
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
  final Map<DateTime, num> cpuTemperature;

  @override
  final Map<DateTime, RamInfo> ramConsumption;

  @override
  final Map<DateTime, num> trafficConsumption;

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
      'trafficConsumption': _toMap(trafficConsumption),
    };
  }

  @override
  String toString() => json.encode(toMap());
}
