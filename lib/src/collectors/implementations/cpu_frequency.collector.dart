import '../../models.dart';
import '../collector.dart';

class AnalysisCpuFrequencyCollector
    implements AnalysisCollector<CpuFrequencies> {
  const AnalysisCpuFrequencyCollector();

  @override
  void collect(CpuFrequencies data) {
    // TODO
  }

  @override
  Extremum<CpuFrequencies> getExtremum() {
    // TODO: implement getExtremum
    throw UnimplementedError();
  }
}
