import '../../models.dart';
import '../collector.dart';

class AnalysisBatteryTemperatureCollector implements AnalysisCollector<double> {
  const AnalysisBatteryTemperatureCollector();

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
