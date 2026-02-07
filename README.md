
# app_analysis

![Build](https://github.com/marchdev-tk/app_analysis/workflows/build/badge.svg)
[![Pub](https://img.shields.io/pub/v/app_analysis.svg)](https://pub.dartlang.org/packages/app_analysis)
![GitHub](https://img.shields.io/github/license/marchdev-tk/app_analysis)
![GitHub stars](https://img.shields.io/github/stars/marchdev-tk/app_analysis?style=social)

A Flutter package to analyze your app's performance, resource usage, and gather runtime information like CPU temperature, memory usage, network traffic, and more.

## Getting Started

`ONLY ANDROID OS IS SUPPORTED!`




---

## Features

- Start and stop app analysis easily.
- Monitor CPU information (temperature, frequency).
- Track memory usage.
- Collect and analyze HTTP traffic data.
- Retrieve comprehensive analysis data as JSON.

---

## Installation

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  app_analysis: ^latest_version
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:app_analysis/app_analysis.dart';
```

### Initialize and Start Analysis

```dart
final analyser = AppAnalyser();
analyser.initialise();

analyser.start();
```

### Stop Analysis and Get Results

```dart
final info = await analyser.stop();

print(info.toMap());
```

### Collecting HTTP Traffic Information

```dart
final request = await HttpClient().getUrl(Uri.parse('https://your-api.com'));
final response = await request.close();

AppAnalyser().collectTraffic(
  HttpClientTrafficConsumptionAdapter(
    HttpClientRequestResponse(request.toExtended(), response.toExtended()),
  ),
);
```

### Getting CPU Information

```dart
final cpuInfo = CpuInfoProvider();

print('Temperature: ${await cpuInfo.temperature}');
print('Average Temp: ${await cpuInfo.averageTemperature}');
print('Current Freq: ${await cpuInfo.currentFrequency}');
print('Extremum Freq: ${await cpuInfo.extremumFrequency}');
```

### Example Output of Analysis Data

```json
{
  "cpu": {
    "temperature": 45.5,
    "averageTemperature": 43.2,
    "currentFrequency": "2.4GHz",
    "extremumFrequency": "1.2GHz - 2.8GHz"
  },
  "memory": {
    "total": "4096MB",
    "used": "1536MB",
    "free": "2560MB"
  },
  "network": {
    "trafficConsumption": [
      {
        "requestSize": "2KB",
        "responseSize": "5KB"
      }
    ]
  }
}
```

## Example App

Check out the example directory for a complete implementation.

## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/marchdev-tk/app_analysis/issues).

## TODO

- Add docs
- Migrate to platform agnostic file operations
- Remove external `battery_info` dependency in favour of custom data provider
- Add interesting data based on analysis results in `AnalysisInfo` model