# cpu_reader

> **Warning**: This is a rewrite of the original with some minor changes to work with the newer Dart Sound Safety specifications

A basic CPU reader that provides a simple way of retrieving device CPU info (Currently only supports Android).

# Usage

To use this rewrite, put this in your `pubspec.yaml`:
```yaml
dependencies:
  better_cpu_reader:
    git:
      url: https://github.com/exoad/better_cpu_reader.git
```

You can view the original package [here](https://github.com/igrik12/cpu_reader).

Example:

```dart
import 'package:better_cpu_reader/cpu_reader.dart';
import 'package:better_cpu_reader/cpuinfo.dart';

CpuInfo cpuInfo = await CpuReader.cpuInfo;
print('Number of Cores ${cpuInfo.numberOfCores}');

int freq = await CpuReader.getCurrentFrequency(2);
print('Core number 2 freq ${freq} Mhz');

CpuReader.asStream(Duration(milliseconds: 1000)).listen((cpuInfo) => print("Temperature: ${cpuInfo.cpuTemperature}"))
```
