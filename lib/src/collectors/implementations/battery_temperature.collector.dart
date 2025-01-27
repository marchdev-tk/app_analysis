// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import '../collector.dart';

const kUnknownBatteryTemperature = -1.0;

abstract class BatteryTemperatureCollectorInterface
    implements
        AnalysisPeriodicalCollectorInterface<num, String>,
        AnalysisCollectorWithExtremumsInterface<num> {}

class BatteryTemperatureCollector
    implements BatteryTemperatureCollectorInterface {
  BatteryTemperatureCollector();

  final Map<DateTime, num> _data = {};

  @override
  Map<DateTime, num> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<num> collect() async {
    ensureOsSupported();

    final temperature = await BatteryInfoProvider().temperature;
    _data[DateTime.now().toUtc()] = temperature;

    return temperature;
  }

  /// Retrieves `SAFE` temperature range for Battery in Celsius
  @override
  Future<Extremum<num>> getExtremum() async {
    return const Extremum(22, 50);
  }

  @override
  String get measurementUnit => '°C';
}
