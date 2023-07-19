import 'dart:async';
import 'dart:collection';
import 'package:better_cpu_reader/cpuinfo.dart';
import 'package:better_cpu_reader/minMaxFreq.dart';
import 'package:flutter/services.dart';

/// This is the [CpuReader] plugin responsible for communication with (Android) platform
/// plugins using asynchronous method calls through [cpu_reader] channel.
class CpuReader {
  static const MethodChannel _channel = const MethodChannel('cpu_reader');
  static late String _abi;
  static late int _numberOfCores;
  static HashMap<int, MinMaxFrequency<int>> _minMaxFrequencies =
      HashMap<int, MinMaxFrequency<int>>();

  /// Listens to any updates of the CPU reader
  static Stream<CpuInfo> asStream(Duration duration) async* {
    while (true) {
      await Future.delayed(duration);
      CpuInfo info = await CpuReader.cpuInfo;
      yield info;
    }
  }

  /// Gets the Android Binary Interface [getAbi] of the device
  static Future<String> getAbi() async {
    try {
      return _abi;
    } on PlatformException catch (e) {
      throw 'Failed to retrieve abi ${e.code}: ${e.message}';
    }
  }

  // Gets the number of cores
  static Future<int> getNumberOfCores() async {
    try {
      return _numberOfCores;
    } on PlatformException catch (e) {
      throw 'Failed to retrieve number of cores ${e.code}: ${e.message}';
    }
  }

  /// Gets the current frequency for the specified [coreNumber]
  static Future<int> getCurrentFrequency(int coreNumber) async {
    try {
      return await _channel
          .invokeMethod('getCurrentFrequency', {"coreNumber": coreNumber});
    } on PlatformException catch (e) {
      throw 'Failed to retrieve current frequency for the core ${e.code}: ${e.message}';
    }
  }

  /// Gets the current min and max frequencies for the specified [coreNumber]
  static Future<MinMaxFrequency<int>?> getMinMaxFrequencies(
      int coreNumber) async {
    try {
      if (_minMaxFrequencies.containsKey(coreNumber)) {
        return _minMaxFrequencies[coreNumber];
      }
      var map = Map<int, int>.from(await _channel
          .invokeMethod('getMinMaxFrequencies', {"coreNumber": coreNumber}));
      var minMax = MinMaxFrequency(map.keys.first, map.values.first);
      _minMaxFrequencies[coreNumber] = minMax;
      return minMax;
    } on PlatformException catch (e) {
      throw 'Failed to retrieve current frequency for the core ${e.code}: ${e.message}';
    }
  }

  /// Retrieves thermal CPU temperature from the device
  static Future<double> getTemperature() async {
    return await _channel.invokeMethod("getCpuTemperature");
  }

  /// This retries the overall information [CpuInfo] of the device CPU.
  static Future<CpuInfo> get cpuInfo async {
    try {
      var cpuInfoJson = await _channel.invokeMethod('getCpuInfo');
      var info = cpuInfoJson;
      var jsonObj = CpuInfo.fromJson(info);
      return jsonObj;
    } on PlatformException catch (e) {
      throw 'Failed to retrieve cpu info ${e.code}: ${e.message}';
    }
  }
}
