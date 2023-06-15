// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';
import 'package:cpu_reader/cpu_reader.dart';
import 'package:cross_platform/cross_platform.dart';

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
    if (!Platform.isAndroid) {
      throw OSNotSupportedError();
    }

    final info = await CpuReader.cpuInfo;
    final freqsRaw = info.currentFrequencies?.values.toList();
    final freqs =
        freqsRaw == null ? CpuFrequency.empty : CpuFrequency(freqsRaw);
    _data[DateTime.now().toUtc()] = freqs;

    return freqs;
  }

  @override
  Future<Extremum<CpuFrequency>> getExtremum() async {
    if (!Platform.isAndroid) {
      throw OSNotSupportedError();
    }

    final info = await CpuReader.cpuInfo;

    if (info.minMaxFrequencies == null) {
      return const Extremum(CpuFrequency.empty, CpuFrequency.empty);
    }

    final mins = <int>[];
    final maxs = <int>[];
    for (var element in info.minMaxFrequencies!.values) {
      mins.add(element.min);
      maxs.add(element.max);
    }

    return Extremum(CpuFrequency(mins), CpuFrequency(maxs));
  }
}
