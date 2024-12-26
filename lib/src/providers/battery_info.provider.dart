// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app_analysis/app_analysis.dart';

import 'implementations/battery_info.android.provider.dart';

class BatteryInfoProvider {
  factory BatteryInfoProvider() => _instance;
  BatteryInfoProvider._();
  static final _instance = BatteryInfoProvider._();

  Future<double> get temperature {
    ensureOsSupported();
    return BatteryInfoAndroidProvider().temperature;
  }

  Future<int> get chargeLevel {
    ensureOsSupported();
    return BatteryInfoAndroidProvider().chargeLevel;
  }
}
