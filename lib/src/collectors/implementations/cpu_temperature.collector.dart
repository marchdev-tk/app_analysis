// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import '../collector.dart';

abstract class CpuTemperatureCollectorInterface
    implements
        AnalysisPeriodicalCollectorInterface<num, String>,
        AnalysisCollectorWithExtremumsInterface<num> {}

class CpuTemperatureCollector implements CpuTemperatureCollectorInterface {
  CpuTemperatureCollector();

  final Map<DateTime, num> _data = {};

  @override
  Map<DateTime, num> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<num> collect() async {
    final temperature = await CpuInfoProvider().averageTemperature;
    _data[DateTime.now().toUtc()] = temperature;

    return temperature;
  }

  /// Retrieves `SAFE` temperature range for CPU in Celsius
  @override
  Future<Extremum<num>> getExtremum() async {
    return const Extremum(22, 65);
  }
  
  @override
  String get measurementUnit => '°C';
}
