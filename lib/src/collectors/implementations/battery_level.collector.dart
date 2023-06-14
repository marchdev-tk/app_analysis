import '../../models.dart';
import '../collector.dart';

class AnalysisBatteryLevelCollector implements AnalysisCollector<double> {
  const AnalysisBatteryLevelCollector();

  @override
  void collect(double data) {
    // TODO
  }

  @override
  Extremum<double> getExtremum() {
    // TODO: implement getExtremum
    throw UnimplementedError();
  }
}
