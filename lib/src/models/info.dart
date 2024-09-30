// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:app_analysis/app_analysis.dart';

import 'data.dart';
import 'extremums.dart';

abstract class AnalysisInfoInterface implements Encodable {
  const AnalysisInfoInterface._();

  String get id;
  DateTime get startedAt;
  DateTime? get endedAt;
  Duration get testDuration;
  AnalysisDataInterface get data;
  AnalysisExtremumsInterface get extremums;
  AnalysisUnitsInterface get units;
}

class AnalysisInfo implements AnalysisInfoInterface {
  factory AnalysisInfo({
    required DateTime startedAt,
    required AnalysisDataInterface data,
    required AnalysisExtremumsInterface extremums,
    required AnalysisUnitsInterface units,
  }) {
    return AnalysisInfo._(
      id: generateRandomId(),
      startedAt: startedAt.toUtc(),
      endedAt: null,
      data: data,
      extremums: extremums,
      units: units,
    );
  }

  factory AnalysisInfo.fromJson(String data) {
    return AnalysisInfo.fromMap(json.decode(data));
  }

  factory AnalysisInfo.fromMap(Map<String, dynamic> map) {
    return AnalysisInfo._(
      id: map['id'],
      startedAt: DateTime.parse(map['startedAt']),
      endedAt: DateTime.tryParse(map['endedAt'] ?? ''),
      data: AnalysisData.fromMap(map['data']),
      extremums: AnalysisExtremums.fromMap(map['extremums']),
      units: AnalysisUnits.fromMap(map['units']),
    );
  }

  const AnalysisInfo._({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.data,
    required this.extremums,
    required this.units,
  });

  @override
  final String id;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  final AnalysisDataInterface data;
  @override
  final AnalysisExtremumsInterface extremums;
  @override
  final AnalysisUnitsInterface units;

  @override
  Duration get testDuration =>
      (endedAt ?? DateTime.now().toUtc()).difference(startedAt);

  // TODO: add getters with interesting data based on results

  AnalysisInfo collectionEnded(DateTime at, AnalysisDataInterface data) {
    return AnalysisInfo._(
      id: id,
      startedAt: startedAt,
      endedAt: at.toUtc(),
      data: data,
      extremums: extremums,
      units: units,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'data': data.toMap(),
      'extremums': extremums.toMap(),
      'units': units.toMap(),
    };
  }

  @override
  String toString() => json.encode(toMap());
}
