// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:app_analysis/app_analysis.dart';
import 'package:flinq/flinq.dart';

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
      for (var file in files) {
        final typeFile = File('${file.path}/type');
        final content = await typeFile.readAsString();
        if (content.contains('cpu')) {
          cpuFiles[content.trim()] = file.path;
        }
      }
      files.clear();

      final cpuData = <String, double>{};
      for (var entry in cpuFiles.entries) {
        final tempFile = File('${entry.value}/temp');
        final content = await tempFile.readAsString();
        cpuData[entry.key] = double.parse(content) / 1000;
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
        final freqFile = File('${file.path}/cpufreq/scaling_cur_freq');
        final content = await freqFile.readAsString();
        final key = int.parse(file.path.split('/').last.replaceAll('cpu', ''));
        cpuData[key] = double.parse(content) / 1000;
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
        final minFile = File('${file.path}/cpufreq/cpuinfo_min_freq');
        final maxFile = File('${file.path}/cpufreq/cpuinfo_max_freq');
        final minContent = await minFile.readAsString();
        final maxContent = await maxFile.readAsString();
        final key = int.parse(file.path.split('/').last.replaceAll('cpu', ''));
        cpuData[key] = Extremum(
          double.parse(minContent) / 1000,
          double.parse(maxContent) / 1000,
        );
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
