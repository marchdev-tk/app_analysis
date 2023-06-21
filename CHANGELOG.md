# Changelog

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
