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
  DateTime get createdAt;
  Duration get testDuration;
  AnalysisDataInterface get data;
  AnalysisExtremumsInterface get extremums;
}

class AnalysisInfo implements AnalysisInfoInterface {
  factory AnalysisInfo({
    required Duration testDuration,
    required AnalysisDataInterface data,
    required AnalysisExtremumsInterface extremums,
  }) {
    return AnalysisInfo._(
      id: generateRandomId(),
      createdAt: DateTime.now().toUtc(),
      testDuration: testDuration,
      data: data,
      extremums: extremums,
    );
  }

  factory AnalysisInfo.fromJson(String data) {
    return AnalysisInfo.fromMap(json.decode(data));
  }

  factory AnalysisInfo.fromMap(Map<String, dynamic> map) {
    return AnalysisInfo._(
      id: map['id'],
      createdAt: map['createdAt'],
      testDuration: map['testDuration'],
      data: AnalysisData.fromMap(map['data']),
      extremums: AnalysisExtremums.fromMap(map['extremums']),
    );
  }

  const AnalysisInfo._({
    required this.id,
    required this.createdAt,
    required this.testDuration,
    required this.data,
    required this.extremums,
  });

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final Duration testDuration;
  @override
  final AnalysisDataInterface data;
  @override
  final AnalysisExtremumsInterface extremums;

  // TODO: add getters with interesting data based on results

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'testDuration': testDuration.inMilliseconds,
      'data': data.toMap(),
      'extremums': extremums.toMap(),
    };
  }

  @override
  String toString() => json.encode(toMap());
}
