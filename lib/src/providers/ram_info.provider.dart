// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app_analysis/app_analysis.dart';

import 'implementations/ram_info.android.provider.dart';

class RamInfoProvider {
  factory RamInfoProvider() => _instance;
  RamInfoProvider._();
  static final _instance = RamInfoProvider._();

  Future<RamInfo> get info {
    ensureOsSupported();
    return RamInfoAndroidProvider().info;
  }

  MemUnit get minAllowedRam {
    ensureOsSupported();
    return RamInfoAndroidProvider().minAllowedRam;
  }
}
