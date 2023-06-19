// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app_analysis/app_analysis.dart';

import 'implementations/ram_info.provider.dart';

const kUnknownRamInfo = RamInfo(total: -1, used: -1, free: -1);

class RamInfoProvider {
  factory RamInfoProvider() => _instance;
  RamInfoProvider._();
  static final _instance = RamInfoProvider._();

  Future<RamInfo> get info => RamInfoAndroidProvider().info;
}
