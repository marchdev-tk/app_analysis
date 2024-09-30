// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import '../collector.dart';

abstract class RamConsumptionCollectorInterface
    implements
        AnalysisPeriodicalCollectorInterface<RamInfo, MemVolUnit>,
        AnalysisCollectorWithExtremumsInterface<MemUnit> {}

class RamConsumptionCollector implements RamConsumptionCollectorInterface {
  RamConsumptionCollector();

  final Map<DateTime, RamInfo> _data = {};

  @override
  Map<DateTime, RamInfo> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<RamInfo> collect() async {
    final info = await RamInfoProvider().info;
    _data[DateTime.now().toUtc()] = info;

    return info;
  }

  /// Retrieves `SAFE` RAM volume range in bytes
  @override
  Future<Extremum<MemUnit>> getExtremum() async {
    final minAllowedRam = RamInfoProvider().minAllowedRam;
    final info = await RamInfoProvider().info;

    return Extremum(minAllowedRam, info.total);
  }

  @override
  MemVolUnit get measurementUnit => MemVolUnit();
}
