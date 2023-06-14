import '../models/extremums.dart';

abstract class AnalysisCollector<T> {
  const AnalysisCollector._();

  void collect(T data);

  Extremum<T> getExtremum();
}
