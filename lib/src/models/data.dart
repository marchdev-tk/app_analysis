import 'cpu_frequencies.dart';

abstract class AnalysisDataInterface {
  const AnalysisDataInterface._();

  Duration get testDuration;

  Map<DateTime, double> get batteryTemperature;
  Map<DateTime, double> get batteryLevel;

  Map<DateTime, double> get cpuTemperature;
  Map<DateTime, CpuFrequencies> get cpuFrequencies;

  Map<DateTime, int> get trafficConsumption;
}

class AnalysisData implements AnalysisDataInterface {
  const AnalysisData({
    required this.testDuration,
    required this.batteryTemperature,
    required this.batteryLevel,
    required this.cpuTemperature,
    required this.cpuFrequencies,
    required this.trafficConsumption,
  });

  static const empty = AnalysisData(
    testDuration: Duration.zero,
    batteryTemperature: {},
    batteryLevel: {},
    cpuTemperature: {},
    cpuFrequencies: {},
    trafficConsumption: {},
  );

  @override
  final Duration testDuration;

  @override
  final Map<DateTime, double> batteryTemperature;
  @override
  final Map<DateTime, double> batteryLevel;

  @override
  final Map<DateTime, double> cpuTemperature;
  @override
  final Map<DateTime, CpuFrequencies> cpuFrequencies;

  @override
  final Map<DateTime, int> trafficConsumption;
}
