// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:app_analysis/app_analysis.dart';

import 'models.dart';

class AppAnalyser {
  factory AppAnalyser() => _instance;
  AppAnalyser._();
  static final _instance = AppAnalyser._();

  late final Duration measurementFrequency;
  late final BatteryLevelCollectorInterface _batteryLevel;
  late final BatteryTemperatureCollectorInterface _batteryTemperature;
  late final CpuFrequencyCollectorInterface _cpuFrequency;
  late final CpuTemperatureCollectorInterface _cpuTemperature;
  late final TrafficConsumptionCollectorInterface _trafficConsumption;
  late final AnalysisStorageInterface _storage;

  AnalysisStoragePurgeInterface get storage => _storage;

  bool _initialised = false;
  Timer? _timer;
  DateTime? _startTime;
  Duration? _testDuration;

  void initialise({
    Duration measurementFrequency = const Duration(seconds: 5),
    BatteryLevelCollectorInterface? batteryLevel,
    BatteryTemperatureCollectorInterface? batteryTemperature,
    CpuFrequencyCollectorInterface? cpuFrequency,
    CpuTemperatureCollectorInterface? cpuTemperature,
    TrafficConsumptionCollectorInterface? trafficConsumption,
    AnalysisStorageInterface? storage,
  }) {
    if (_initialised) {
      throw AnalyserAlreadyInitializedException();
    }

    this.measurementFrequency = measurementFrequency;
    _batteryLevel = batteryLevel ?? BatteryLevelCollector();
    _batteryTemperature = batteryTemperature ?? BatteryTemperatureCollector();
    _cpuFrequency = cpuFrequency ?? CpuFrequencyCollector();
    _cpuTemperature = cpuTemperature ?? CpuTemperatureCollector();
    _trafficConsumption = trafficConsumption ??
        TrafficConsumptionCollector<RawTrafficConsumptionAdapter>();
    _storage = storage ?? AnalysisMemoryStorage();

    _initialised = true;
  }

  void start() {
    if (_timer != null || _startTime != null) {
      throw AnalysisInProgressException();
    }

    _startTime = DateTime.now();
    _timer = Timer.periodic(
      measurementFrequency,
      (_) {
        _batteryLevel.collect();
        _batteryTemperature.collect();
        _cpuFrequency.collect();
        _cpuTemperature.collect();
      },
    );
  }

  Future<AnalysisInfoInterface> stop() async {
    if (_timer == null || _startTime == null) {
      throw AnalysisNotStartedException();
    }

    _timer!.cancel();
    _timer = null;
    _testDuration = DateTime.now().difference(_startTime!);
    _startTime = null;

    final info = AnalysisInfo(
      testDuration: _testDuration!,
      data: _getData(),
      extremums: await _getExtremums(),
    );
    _storage.create(info);
    _clearData();

    return info;
  }

  void collectTraffic(TrafficConsumptionAdapter adapter) {
    if (_timer == null || _startTime == null) {
      return;
    }

    _trafficConsumption.collect(adapter);
  }

  void _clearData() {
    _batteryLevel.clearData();
    _batteryTemperature.clearData();
    _cpuFrequency.clearData();
    _cpuTemperature.clearData();
  }

  AnalysisDataInterface _getData() {
    return AnalysisData(
      batteryLevel: _batteryLevel.data,
      batteryTemperature: _batteryTemperature.data,
      cpuFrequency: _cpuFrequency.data,
      cpuTemperature: _cpuTemperature.data,
      trafficConsumption: _trafficConsumption.data,
    );
  }

  Future<AnalysisExtremumsInterface> _getExtremums() async {
    final results = await Future.wait([
      _batteryLevel.getExtremum(),
      _batteryTemperature.getExtremum(),
      _cpuFrequency.getExtremum(),
      _cpuTemperature.getExtremum(),
    ]);
    return AnalysisExtremums(
      batteryLevel: results[0] as Extremum<int>,
      batteryTemperature: results[1] as Extremum<int>,
      cpuFrequency: results[2] as Extremum<CpuFrequency>,
      cpuTemperature: results[3] as Extremum<double>,
    );
  }
}

// • Collector
//   ○ RAM consumption (every 30 sec)
