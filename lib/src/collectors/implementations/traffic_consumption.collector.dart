// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import '../collector.dart';

abstract class TrafficConsumptionAdapter<T> {
  T get value;
  FutureOr<int> get contentLength;
}

abstract class TrafficConsumptionCollectorInterface<
        T extends TrafficConsumptionAdapter>
    implements AnalysisOnDemandCollectorInterface<MemUnit, T, MemVolUnit> {}

class TrafficConsumptionCollector<T extends TrafficConsumptionAdapter>
    implements TrafficConsumptionCollectorInterface<T> {
  TrafficConsumptionCollector();

  final Map<DateTime, MemUnit> _data = {};

  @override
  Map<DateTime, MemUnit> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<MemUnit> collect(T value) async {
    final volume = MemUnit(await value.contentLength);
    _data[DateTime.now().toUtc()] = volume;

    return volume;
  }

  @override
  MemVolUnit get measurementUnit => MemVolUnit();
}
