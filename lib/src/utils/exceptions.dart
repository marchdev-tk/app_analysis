// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cross_platform/cross_platform.dart';

class OSNotSupportedError extends Error {
  @override
  String toString() =>
      'Current OS (${Platform.operatingSystem}) is not supported';
}

class AnalysisInProgressException implements Exception {
  @override
  String toString() => 'Analysis already in progress';
}

class AnalysisNotStartedException implements Exception {
  @override
  String toString() => 'Analysis have not started yet';
}

class AnalyserAlreadyInitializedException implements Exception {
  @override
  String toString() => 'Analyser has already been initialised';
}
