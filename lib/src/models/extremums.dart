import 'cpu_frequencies.dart';

class Extremum<T> {
  const Extremum(this.min, this.max);

  final T min;
  final T max;
}

abstract class AnalysisExtremumsInterface {
  const AnalysisExtremumsInterface._();

  Extremum<double> get batteryTemperature;
  Extremum<double> get batteryLevel;

  Extremum<double> get cpuTemperature;
  Extremum<CpuFrequencies> get cpuFrequencies;
}

class AnalysisExtremums implements AnalysisExtremumsInterface {
  const AnalysisExtremums({
    required this.batteryTemperature,
    required this.batteryLevel,
    required this.cpuTemperature,
    required this.cpuFrequencies,
  });

  @override
  final Extremum<double> batteryTemperature;
  @override
  final Extremum<double> batteryLevel;

  @override
  final Extremum<double> cpuTemperature;
  @override
  final Extremum<CpuFrequencies> cpuFrequencies;
}
