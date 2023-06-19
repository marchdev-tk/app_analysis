// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_analysis/app_analysis.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppAnalysis Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnalysisInfoInterface? info;
  String? cpuInfo;
  String? memInfo;

  String getInfoData() {
    final raw = info?.toMap() ?? {};
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(raw);
  }

  @override
  void initState() {
    AppAnalyser().initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppAnalysis Example'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () => AppAnalyser().start(),
              child: const Text('Start Analysis'),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                info = await AppAnalyser().stop();
                setState(() {});
              },
              child: const Text('Stop Analysis'),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SelectableText(getInfoData()),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                cpuInfo = (await CpuInfoProvider().temperature).toString() +
                    '\n\n' +
                    (await CpuInfoProvider().currentFrequency).toString() +
                    '\n\n' +
                    (await CpuInfoProvider().extremumFrequency).toString();
                setState(() {});
              },
              child: const Text('Get Cpu Info'),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SelectableText(cpuInfo ?? '-'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                memInfo = 'Total: ' +
                    (await RamInfoProvider().info).total.toString() +
                    '\n' +
                    'Free: ' +
                    (await RamInfoProvider().info).free.toString() +
                    '\n' +
                    'Used: ' +
                    (await RamInfoProvider().info).used.toString();
                setState(() {});
              },
              child: const Text('Get Memory Info'),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SelectableText(memInfo ?? '-'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
