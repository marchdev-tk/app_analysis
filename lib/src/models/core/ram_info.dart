// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'encodable.dart';
import 'mem_unit.dart';

class RamInfo implements Encodable {
  const RamInfo({
    required this.total,
    required this.used,
    required this.available,
  });

  factory RamInfo.fromMap(Map<String, dynamic> map) {
    return RamInfo(
      total: map['total'],
      used: map['used'],
      available: map['available'],
    );
  }

  static const unknown = RamInfo(
    total: MemUnit.unknown,
    used: MemUnit.unknown,
    available: MemUnit.unknown,
  );

  final MemUnit total;
  final MemUnit used;
  final MemUnit available;

  double get percentUsed => used.bytes / total.bytes;
  double get percentAvailable => available.bytes / total.bytes;

  @override
  Map<String, dynamic> toMap() {
    return {
      'total': total.bytes,
      'used': used.bytes,
      'available': available.bytes,
    };
  }
}
