// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../models.dart';

abstract class AnalysisCollectorInterface<T> {
  const AnalysisCollectorInterface._();

  Map<DateTime, T> get data;
  void clearData();

  String get measurementUnit;
}

abstract class AnalysisCollectorWithExtremumsInterface<T> {
  const AnalysisCollectorWithExtremumsInterface._();

  Future<Extremum<T>> getExtremum();
}

abstract class AnalysisPeriodicalCollectorInterface<T>
    implements AnalysisCollectorInterface<T> {
  const AnalysisPeriodicalCollectorInterface._();

  Future<T> collect();
}

abstract class AnalysisOnDemandCollectorInterface<T, E>
    implements AnalysisCollectorInterface<T> {
  const AnalysisOnDemandCollectorInterface._();

  Future<T> collect(E value);
}
