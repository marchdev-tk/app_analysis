// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class MemVolUnit {
  factory MemVolUnit() => _instance;
  const MemVolUnit._();
  static const _instance = MemVolUnit._();

  String get inBytes => 'B';

  String get inKB => 'KB';
  String get inMB => 'MB';
  String get inGB => 'GB';

  String get inKiB => 'KiB';
  String get inMiB => 'MiB';
  String get inGiB => 'GiB';
}
