// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../models.dart';
import '../storage.dart';

class AnalysisMemoryStorage implements AnalysisStorageInterface {
  AnalysisMemoryStorage();

  final _storage = <String, AnalysisInfoInterface>{};

  @override
  Future<List<AnalysisInfoInterface>> readAll() async =>
      _storage.values.toList();
  @override
  Future<AnalysisInfoInterface?> read(String id) async => _storage[id];

  @override
  Future<void> create(AnalysisInfoInterface info) async =>
      _storage[info.id] = info;

  @override
  Future<void> delete(String id) async => _storage.remove(id);
  @override
  Future<void> deleteAll() async => _storage.clear();
}
