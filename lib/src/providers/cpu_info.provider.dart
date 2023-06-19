// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app_analysis/app_analysis.dart';
import 'package:flinq/flinq.dart';

import 'implementations/cpu_info.android.provider.dart';

const kUnknownCpuTemperature = -1.0;
const kUnknownCpuFrequency = -1.0;
const kUnknownCpuExtremumFrequency =
    Extremum(kUnknownCpuFrequency, kUnknownCpuFrequency);

class CpuInfoProvider {
  factory CpuInfoProvider() => _instance;
  CpuInfoProvider._();
  static final _instance = CpuInfoProvider._();

  Future<Map<String, double>> get temperature {
    ensureOsSupported();
    return CpuInfoAndroidProvider().temperature;
  }

  Future<double> get averageTemperature async =>
      (await temperature).values.average.toDouble();

  Future<Map<int, double>> get currentFrequency {
    ensureOsSupported();
    return CpuInfoAndroidProvider().currentFrequency;
  }

  Future<double> get averageCurrentFrequency async =>
      (await currentFrequency).values.average.toDouble();

  Future<Map<int, Extremum<double>>> get extremumFrequency {
    ensureOsSupported();
    return CpuInfoAndroidProvider().extremumFrequency;
  }
}
