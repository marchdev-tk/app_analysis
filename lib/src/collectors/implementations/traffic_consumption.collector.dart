import '../collector.dart';

abstract class TrafficConsumptionCollectorInterface
    implements AnalysisOnDemandCollectorInterface<num, dynamic> {}

class TrafficConsumptionCollector
    implements TrafficConsumptionCollectorInterface {
  TrafficConsumptionCollector();

  final Map<DateTime, num> _data = {};

  @override
  Map<DateTime, num> get data => Map.unmodifiable(_data);

  @override
  void clearData() => _data.clear();

  @override
  Future<num> collect(dynamic value) async {
    // TODO: implement collect
    throw UnimplementedError();
  }
}
