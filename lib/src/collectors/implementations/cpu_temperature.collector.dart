// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';
import 'package:cpu_reader/cpu_reader.dart';
import 'package:cross_platform/cross_platform.dart';

const kUnknownCpuTemperature = -1;

abstract class CpuTemperatureCollectorInterface
    implements AnalysisCollectorInterface<num> {}

class CpuTemperatureCollector implements CpuTemperatureCollectorInterface {
  CpuTemperatureCollector();

  final Map<DateTime, num> _data = {};

  @override
  Map<DateTime, num> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<num> collect() async {
    if (!Platform.isAndroid) {
      throw OSNotSupportedError();
    }

    final info = await CpuReader.cpuInfo;
    final temperature = info.cpuTemperature ?? kUnknownCpuTemperature;
    _data[DateTime.now().toUtc()] = temperature;

    return temperature;
  }

  /// Retrieves `SAFE` temperature range for CPU in Celsius
  @override
  Future<Extremum<num>> getExtremum() async {
    return const Extremum(22, 65);
  }
}
