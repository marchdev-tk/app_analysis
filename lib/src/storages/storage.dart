// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../models.dart';

abstract class AnalysisStoragePurgeInterface {
  Future<List<AnalysisInfoInterface>> readAll();
  Future<AnalysisInfoInterface?> read(String id);

  Future<void> delete(String id);
  Future<void> deleteAll();
}

abstract class AnalysisStorageCreateInterface {
  Future<void> create(AnalysisInfoInterface info);
}

abstract class AnalysisStorageInterface
    implements AnalysisStoragePurgeInterface, AnalysisStorageCreateInterface {}
