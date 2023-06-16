// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'encodable.dart';

class Extremum<T> implements Encodable {
  const Extremum(this.min, this.max);

  factory Extremum.fromMap(
    Map<String, dynamic> map, [
    T Function(dynamic value)? convert,
  ]) {
    return Extremum(
      convert?.call(map['min']) ?? map['min'] as T,
      convert?.call(map['max']) ?? map['max'] as T,
    );
  }

  final T min;
  final T max;

  @override
  Map<String, dynamic> toMap([dynamic Function(T value)? convert]) {
    return {
      'min': convert?.call(min) ?? min,
      'max': convert?.call(max) ?? max,
    };
  }

  @override
  String toString() => json.encode(toMap());
}
