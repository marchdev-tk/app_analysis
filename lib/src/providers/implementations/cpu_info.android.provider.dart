// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:app_analysis/app_analysis.dart';
import 'package:flinq/flinq.dart';

enum _SensorKind {
  cpu('cpu'),
  tsensTzSensor('tsens_tz_sensor'),
  unknown('unknown');

  const _SensorKind(this.kind);

  factory _SensorKind.fromString(String value) {
    return values.firstOrNullWhere((item) => value.contains(item.kind)) ??
        unknown;
  }

  final String kind;
}

class CpuInfoAndroidProvider {
  factory CpuInfoAndroidProvider() => _instance;
  CpuInfoAndroidProvider._();
  static final _instance = CpuInfoAndroidProvider._();

  static const _thermalDir = 'sys/class/thermal';
  static const _cpuInfoDir = '/sys/devices/system/cpu';

  /// In °C
  Future<Map<String, double>> _readTemperature() async {
    try {
      var files = <FileSystemEntity>[];
      await Directory(_thermalDir).list().forEach(files.add);
      files = files.whereList((e) => e.path.contains('thermal_zone'))
        ..sort((a, b) => a.path.compareTo(b.path));

      final cpuFiles = <String, String>{};
      final cpuSensorKind = <String, _SensorKind>{};
      for (var file in files) {
        final typeFile = File('${file.path}/type');
        final content = (await typeFile.readAsString()).trim();
        final kind = _SensorKind.fromString(content);
        if (kind != _SensorKind.unknown) {
          cpuFiles[content] = file.path;
          cpuSensorKind[content] = kind;
        }
      }
      files.clear();

      final cpuData = <String, double>{};
      for (var entry in cpuFiles.entries) {
        final tempFile = File('${entry.value}/temp');
        final content = (await tempFile.readAsString()).trim();

        switch (cpuSensorKind[entry.key]) {
          case _SensorKind.cpu:
            cpuData[entry.key] = double.parse(content) / 1000;
            break;
          case _SensorKind.tsensTzSensor:
            cpuData[entry.key] = double.parse(content);
            break;

          default:
            cpuData[entry.key] = kUnknownCpuTemperature;
        }
      }
      cpuFiles.clear();

      return cpuData;
    } catch (e) {
      return {'error': kUnknownCpuTemperature};
    }
  }

  /// In Mhz
  Future<Map<int, double>> _readCurrentFrequency() async {
    try {
      var files = <FileSystemEntity>[];
      await Directory(_cpuInfoDir).list().forEach(files.add);
      files = files.whereList((e) => RegExp(r'cpu[0-9]+').hasMatch(e.path))
        ..sort((a, b) => a.path.compareTo(b.path));

      final cpuData = <int, double>{};
      for (var file in files) {
        final key = int.parse(file.path.split('/').last.replaceAll('cpu', ''));
        final freqDir = Directory('${file.path}/cpufreq');
        if (await freqDir.exists()) {
          final freqFile = File('${file.path}/cpufreq/scaling_cur_freq');
          if (await freqFile.exists()) {
            final content = await freqFile.readAsString();
            cpuData[key] = double.parse(content) / 1000;
          } else {
            cpuData[key] = kUnknownCpuFrequency;
          }
        } else {
          cpuData[key] = kUnknownCpuFrequency;
        }
      }
      files.clear();

      return cpuData;
    } catch (e) {
      return {0: kUnknownCpuFrequency};
    }
  }

  /// In Mhz
  Future<Map<int, Extremum<double>>> _readExtremumFrequency() async {
    try {
      var files = <FileSystemEntity>[];
      await Directory(_cpuInfoDir).list().forEach(files.add);
      files = files.whereList((e) => RegExp(r'cpu[0-9]+').hasMatch(e.path))
        ..sort((a, b) => a.path.compareTo(b.path));

      final cpuData = <int, Extremum<double>>{};
      for (var file in files) {
        final key = int.parse(file.path.split('/').last.replaceAll('cpu', ''));
        final freqDir = Directory('${file.path}/cpufreq');
        if (await freqDir.exists()) {
          final minFile = File('${file.path}/cpufreq/cpuinfo_min_freq');
          final maxFile = File('${file.path}/cpufreq/cpuinfo_max_freq');
          if (await minFile.exists() && await maxFile.exists()) {
            final minContent = await minFile.readAsString();
            final maxContent = await maxFile.readAsString();
            cpuData[key] = Extremum(
              double.parse(minContent) / 1000,
              double.parse(maxContent) / 1000,
            );
          } else {
            cpuData[key] = kUnknownCpuExtremumFrequency;
          }
        } else {
          cpuData[key] = kUnknownCpuExtremumFrequency;
        }
      }
      files.clear();

      return cpuData;
    } catch (e) {
      return {0: kUnknownCpuExtremumFrequency};
    }
  }

  Future<Map<String, double>> get temperature => _readTemperature();

  Future<Map<int, double>> get currentFrequency => _readCurrentFrequency();

  Future<Map<int, Extremum<double>>> get extremumFrequency =>
      _readExtremumFrequency();
}
