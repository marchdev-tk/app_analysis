// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flinq/flinq.dart';

import '../../models.dart';
import '../storage.dart';

class AnalysisFileStorage implements AnalysisStorageInterface {
  AnalysisFileStorage();

  static const fileExtension = '.json';

  Directory get _workingDir => Directory('${Directory.current.path}/analysis');

  @override
  Future<List<AnalysisInfoInterface>> readAll() async {
    final files = <FileSystemEntity>[];
    await _workingDir.list().forEach(files.add);
    final contents =
        await Future.wait(files.map((f) => File(f.path).readAsString()));
    return contents.mapList(AnalysisInfo.fromJson);
  }

  @override
  Future<AnalysisInfoInterface?> read(String id) async {
    final file = File('${_workingDir.path}$id$fileExtension');
    final content = await file.readAsString();
    return AnalysisInfo.fromJson(content);
  }

  @override
  Future<void> create(AnalysisInfoInterface info) async {
    final file = File('${_workingDir.path}${info.id}$fileExtension');
    await file.writeAsString(info.toString(), flush: true);
  }

  @override
  Future<void> delete(String id) async {
    final file = File('${_workingDir.path}$id$fileExtension');
    await file.delete();
  }

  @override
  Future<void> deleteAll() async => _workingDir.delete(recursive: true);
}
