// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:app_analysis/app_analysis.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryInfoAndroidProvider {
  factory BatteryInfoAndroidProvider() => _instance;
  BatteryInfoAndroidProvider._();
  static final _instance = BatteryInfoAndroidProvider._();

  Future<double> get temperature async {
    try {
      final file = File('/sys/class/thermal/thermal_zone0/temp');

      if (!file.existsSync()) {
        return kUnknownBatteryTemperature;
      }

      final rawTemp = await file.readAsString();
      final parsedTemp = int.parse(rawTemp.trim());
      return parsedTemp / 1000;
    } catch (e) {
      return kUnknownBatteryTemperature;
    }
  }

  Future<int> get chargeLevel async {
    try {
      return await Battery().batteryLevel;
      //   final file = File('/sys/class/power_supply/battery/charge_full');

      //   if (!file.existsSync()) {
      //     return kUnknownBatteryLevel;
      //   }

      //   final rawLevel = await file.readAsString();
      //   return int.parse(rawLevel.trim());
    } catch (e) {
      return kUnknownBatteryLevel;
    }
  }
}
