// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:app_analysis/app_analysis.dart';

abstract class AnalysisExtremumsInterface implements Encodable {
  const AnalysisExtremumsInterface._();

  Extremum<num> get batteryLevel;
  Extremum<num> get batteryTemperature;

  Extremum<CpuFrequency> get cpuFrequency;
  Extremum<num> get cpuTemperature;
}

class AnalysisExtremums implements AnalysisExtremumsInterface {
  const AnalysisExtremums({
    required this.batteryLevel,
    required this.batteryTemperature,
    required this.cpuFrequency,
    required this.cpuTemperature,
  });

  factory AnalysisExtremums.fromMap(Map<String, dynamic> map) {
    return AnalysisExtremums(
      batteryLevel: Extremum<num>.fromMap(map['batteryLevel']),
      batteryTemperature: Extremum<num>.fromMap(map['batteryTemperature']),
      cpuFrequency: Extremum<CpuFrequency>.fromMap(
        map['cpuFrequency'],
        (value) => CpuFrequency(value as List<num>),
      ),
      cpuTemperature: Extremum<num>.fromMap(map['cpuTemperature']),
    );
  }

  @override
  final Extremum<num> batteryLevel;
  @override
  final Extremum<num> batteryTemperature;

  @override
  final Extremum<CpuFrequency> cpuFrequency;
  @override
  final Extremum<num> cpuTemperature;

  @override
  Map<String, dynamic> toMap() {
    return {
      'batteryLevel': batteryLevel.toMap(),
      'batteryTemperature': batteryTemperature.toMap(),
      'cpuFrequency': cpuFrequency.toMap((value) => value.frequencies),
      'cpuTemperature': cpuTemperature.toMap(),
    };
  }

  @override
  String toString() => json.encode(toMap());
}
