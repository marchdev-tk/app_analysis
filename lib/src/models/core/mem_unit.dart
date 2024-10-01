// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class MemUnit implements Comparable<MemUnit> {
  const MemUnit(this.bytes);
  factory MemUnit.fromKB(double kib) => MemUnit((kib * 1024).toInt());
  factory MemUnit.fromMB(double mib) => MemUnit.fromKB(mib * 1024);
  factory MemUnit.fromGB(double gib) => MemUnit.fromMB(gib * 1024);

  static const unknown = MemUnit(-1);

  final int bytes;

  double get inKB => bytes / 1000;
  double get inMB => inKB / 1000;
  double get inGB => inMB / 1000;

  double get inKiB => bytes / 1024;
  double get inMiB => inKiB / 1024;
  double get inGiB => inMiB / 1024;

  MemUnit operator +(MemUnit other) => MemUnit(bytes + other.bytes);
  MemUnit operator -(MemUnit other) => MemUnit(bytes - other.bytes);
  MemUnit operator *(num multiplier) => MemUnit((bytes * multiplier).toInt());
  MemUnit operator /(num divider) => MemUnit(bytes ~/ divider);

  @override
  int compareTo(MemUnit other) => bytes.compareTo(other.bytes);

  @override
  int get hashCode => bytes.hashCode;

  @override
  bool operator ==(covariant MemUnit other) => bytes == other.bytes;
}
