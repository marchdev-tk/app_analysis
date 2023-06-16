// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../collector.dart';

abstract class TrafficConsumptionAdapter<T> {
  T get value;
  int get contentLength;
}

abstract class TrafficConsumptionCollectorInterface<
        T extends TrafficConsumptionAdapter>
    implements AnalysisOnDemandCollectorInterface<num, T> {}

class TrafficConsumptionCollector<T extends TrafficConsumptionAdapter>
    implements TrafficConsumptionCollectorInterface<T> {
  TrafficConsumptionCollector();

  final Map<DateTime, num> _data = {};

  @override
  Map<DateTime, num> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<num> collect(T value) async => value.contentLength;
}
