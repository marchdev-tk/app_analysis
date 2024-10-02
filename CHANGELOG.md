# Changelog

# 0.2.4

* Added getters of `AnalysisDataInterface` different views, such as:
  * `getCpuUsagePercents`
  * `ramConsumptionPercents`
  * `trafficConsumptionCumulative`

# 0.2.3

* Added separate `AppAnalyser.onDataCollected` setter for more flexibility
* Implemented for every data type `hashCode` and `equals`

# 0.2.2

* Set Dart constraint to `>=3.3.0`
* Fixed `HttpClientTrafficConsumptionAdapter`
* Added to example dummy request 

# 0.2.1

* Changed for `TrafficConsumptionCollectorInterface` collectable type from `num` to `MemUnit`

## 0.2.0

* Added ability to receive collected data on a go via callback `AppAnalysis.onDataCollected`
* Added data collection as soon as collection starts
* Reimplemented `AppAnalysis.start` to return `Future<AnalysisInfoInterface>` instead of void, and it will contain all available at that moment data whereas `AppAnalysis.stop` will return finalised data
* Renamed `MemUnit.inKB` to `MemUnit.inKiB`, `MemUnit.inMB` to `MemUnit.inMiB` and `MemUnit.inGB` to `MemUnit.inGiB`
* Added new getters `MemUnit.inKB`, `MemUnit.inMB` and `MemUnit.inGB`
* Added new `MemVolUnit` which represents different measurement units of a memory volumes
* Changed `AnalysisUnitsInterface` and collectors to use `MemVolUnit` instead of a plain `String`

## 0.1.5

* Fixed parsing issue of `AnalysisData` model and `RamInfo` model

## 0.1.4

* Fixed yet another parsing issue of `AnalysisInfo` model

## 0.1.3

* Fixed parsing issue of `AnalysisInfo` model

## 0.1.2

* Fixed yet another `AnalysisFileStorage` saving directory issue 

## 0.1.1

* Fixed `AnalysisFileStorage` saving directory issue 

## 0.1.0

**ANDROID ONLY**

* Implemented `AppAnalyser` that can collect, get extremum values and analyse following data:
  * Battery Level
  * Battery Temperature
  * CPU Frequency
  * CPU Temperature
  * RAM Consumption
  * Traffic Consumption
* Implemented storages for analysis results
  * `AnalysisMemoryStorage`
  * `AnalysisFileStorage`
* Implemented system data providers for:
  * CPU Frequency
  * CPU Temperature
  * RAM Consumption
