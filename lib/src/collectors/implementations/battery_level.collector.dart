// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import '../collector.dart';

const kUnknownBatteryLevel = -1;

abstract class BatteryLevelCollectorInterface
    implements
        AnalysisPeriodicalCollectorInterface<num, String>,
        AnalysisCollectorWithExtremumsInterface<num> {}

class BatteryLevelCollector implements BatteryLevelCollectorInterface {
  BatteryLevelCollector();

  final Map<DateTime, num> _data = {};

  @override
  Map<DateTime, num> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<num> collect() async {
    ensureOsSupported();

    final batteryLevel = await BatteryInfoProvider().chargeLevel;
    _data[DateTime.now().toUtc()] = batteryLevel;

    return batteryLevel;
  }

  @override
  Future<Extremum<num>> getExtremum() async {
    return const Extremum(0, 100);
  }

  @override
  String get measurementUnit => '%';
}
