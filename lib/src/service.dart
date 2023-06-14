import 'models.dart';

class AnalysisService {
  factory AnalysisService() => _instance;
  const AnalysisService._();
  static const _instance = AnalysisService._();

  void start() {
    // TODO
  }

  void stop() {
    // TODO
  }

  AnalysisExtremums getExtremums() {
    // TODO: implement getExtremums
    throw UnimplementedError();
  }
}

// • Collector
//   ○ Battery consumption % (every 30 sec)
//   ○ RAM consumption (every 30 sec)
//   ○ Network traffic consumption (per request)
//
// • Method to form ResultInfo (test duration, collectors results, RAM min max avg values)