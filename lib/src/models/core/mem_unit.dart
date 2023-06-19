// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class MemUnit implements Comparable<MemUnit> {
  const MemUnit(this.bytes);
  factory MemUnit.fromKB(double kb) => MemUnit((kb * 1024).toInt());
  factory MemUnit.fromMB(double mb) => MemUnit.fromKB(mb * 1024);
  factory MemUnit.fromGB(double gb) => MemUnit.fromMB(gb * 1024);

  static const unknown = MemUnit(-1);

  final int bytes;

  double get inKB => bytes / 1024;
  double get inMB => inKB / 1024;
  double get inGB => inMB / 1024;

  MemUnit operator +(MemUnit other) => MemUnit(bytes + other.bytes);
  MemUnit operator -(MemUnit other) => MemUnit(bytes - other.bytes);
  MemUnit operator *(num multiplier) => MemUnit((bytes * multiplier).toInt());
  MemUnit operator /(num divider) => MemUnit(bytes ~/ divider);

  @override
  int compareTo(MemUnit other) => bytes.compareTo(other.bytes);
}
