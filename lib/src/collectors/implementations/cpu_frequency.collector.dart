// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import '../collector.dart';

abstract class CpuFrequencyCollectorInterface
    implements
        AnalysisPeriodicalCollectorInterface<CpuFrequency>,
        AnalysisCollectorWithExtremumsInterface<CpuFrequency> {}

class CpuFrequencyCollector implements CpuFrequencyCollectorInterface {
  CpuFrequencyCollector();

  final Map<DateTime, CpuFrequency> _data = {};

  @override
  Map<DateTime, CpuFrequency> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<CpuFrequency> collect() async {
    ensureOsSupported();

    final info = await CpuInfoProvider().currentFrequency;
    final freqs = CpuFrequency(info.values.toList());
    _data[DateTime.now().toUtc()] = freqs;

    return freqs;
  }

  @override
  Future<Extremum<CpuFrequency>> getExtremum() async {
    ensureOsSupported();

    final info = await CpuInfoProvider().extremumFrequency;

    final mins = <double>[];
    final maxs = <double>[];
    for (var element in info.values) {
      mins.add(element.min);
      maxs.add(element.max);
    }

    return Extremum(CpuFrequency(mins), CpuFrequency(maxs));
  }
}
