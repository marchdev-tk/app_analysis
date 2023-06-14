import '../../models.dart';
import '../collector.dart';

class AnalysisCpuTemperatureCollector implements AnalysisCollector<double> {
  const AnalysisCpuTemperatureCollector();

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
