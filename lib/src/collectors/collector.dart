// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../models.dart';

abstract class AnalysisCollectorInterface<T> {
  const AnalysisCollectorInterface._();

  Map<DateTime, T> get data;
  void clearData();

  Future<T> collect();
  Future<Extremum<T>> getExtremum();
}
