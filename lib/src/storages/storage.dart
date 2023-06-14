import 'dart:async';

import '../models.dart';

abstract class AnalysisStorage {
  FutureOr<AnalysisInfo> readAll();
  FutureOr<AnalysisInfo> read(String id);

  FutureOr<void> create(AnalysisInfo info);

  FutureOr<void> clear(String id);
  FutureOr<void> clearAll();
}

// • AnalysisStorage abstract model, ready to extend
//   ○ File
//   ○ Memory
//   ○ Preferences
// • Methods to Clear One/Clear All analysis results