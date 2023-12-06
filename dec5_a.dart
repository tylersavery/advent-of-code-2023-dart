import 'utils/files.dart';

class SeedMap {
  SeedMap({
    required this.seeds,
    required this.seedToSoilMap,
    required this.soilToFertilizerMap,
    required this.fertilizerToWaterMap,
    required this.waterToLightMap,
    required this.lightToTemperatureMap,
    required this.temperatureToHumidityMap,
    required this.humidityToLocationMap,
  });

  final Set<int> seeds;
  final List<SeedLine> seedToSoilMap;
  final List<SeedLine> soilToFertilizerMap;
  final List<SeedLine> fertilizerToWaterMap;
  final List<SeedLine> waterToLightMap;
  final List<SeedLine> lightToTemperatureMap;
  final List<SeedLine> temperatureToHumidityMap;
  final List<SeedLine> humidityToLocationMap;

  int seedToLocation(int seed) {
    final soil = sourceToDest(seed, seedToSoilMap);
    final fertilizer = sourceToDest(soil, soilToFertilizerMap);
    final water = sourceToDest(fertilizer, fertilizerToWaterMap);
    final light = sourceToDest(water, waterToLightMap);
    final temperature = sourceToDest(light, lightToTemperatureMap);
    final humidity = sourceToDest(temperature, temperatureToHumidityMap);
    final location = sourceToDest(humidity, humidityToLocationMap);

    return location;
  }

  int locationToSeed(int location) {
    final humidity = destToSource(location, humidityToLocationMap);
    final temperature = destToSource(humidity, temperatureToHumidityMap);
    final light = destToSource(temperature, lightToTemperatureMap);
    final water = destToSource(light, waterToLightMap);
    final fertilizer = destToSource(water, fertilizerToWaterMap);
    final soil = destToSource(fertilizer, soilToFertilizerMap);
    final seed = destToSource(soil, seedToSoilMap);

    return seed;
  }

  int sourceToDest(int source, List<SeedLine> destMap) {
    final exists = destMap.indexWhere((e) => e.containsSource(source)) != -1;

    if (exists) {
      return destMap.firstWhere((e) => e.containsSource(source)).sourceToDest(source);
    }
    return source;
  }

  int destToSource(int dest, List<SeedLine> sourceMap) {
    final exists = sourceMap.indexWhere((e) => e.containsDest(dest)) != -1;
    if (exists) {
      return sourceMap.firstWhere((e) => e.containsDest(dest)).destToSource(dest);
    }

    return dest;
  }
}

class SeedLine {
  const SeedLine({
    required this.destinationRangeStart,
    required this.sourceRangeStart,
    required this.rangeLength,
  });

  factory SeedLine.parse(String line) {
    final parts = line.split(' ');
    return SeedLine(
      destinationRangeStart: int.parse(parts[0]),
      sourceRangeStart: int.parse(parts[1]),
      rangeLength: int.parse(parts[2]),
    );
  }

  final int destinationRangeStart;
  final int sourceRangeStart;
  final int rangeLength;

  bool containsSource(int source) {
    return source >= sourceRangeStart && source < sourceRangeStart + rangeLength;
  }

  int sourceToDest(int source) {
    return source - sourceRangeStart + destinationRangeStart;
  }

  bool containsDest(int dest) {
    return dest >= destinationRangeStart && dest < destinationRangeStart + rangeLength;
  }

  int destToSource(int dest) {
    return dest - destinationRangeStart + sourceRangeStart;
  }
}

SeedMap parseData(List<String> lines) {
  final seeds = lines[0].replaceAll('seeds: ', '').split(' ').map(int.parse).toSet();

  final seedToSoil = <SeedLine>[];
  final soilToFertilizer = <SeedLine>[];
  final fertilizerToWater = <SeedLine>[];
  final waterToLight = <SeedLine>[];
  final lightToTemperature = <SeedLine>[];
  final temperatureToHumidity = <SeedLine>[];
  final humidityToLocation = <SeedLine>[];

  for (int index = 1; index < lines.length; index++) {
    final line = lines[index];
    if (line.startsWith('seed-to-soil map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        seedToSoil.add(SeedLine.parse(lines[nextIndex]));
      }
    } else if (line.startsWith('soil-to-fertilizer map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        soilToFertilizer.add(SeedLine.parse(lines[nextIndex]));
      }
    } else if (line.startsWith('fertilizer-to-water map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        fertilizerToWater.add(SeedLine.parse(lines[nextIndex]));
      }
    } else if (line.startsWith('water-to-light map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        waterToLight.add(SeedLine.parse(lines[nextIndex]));
      }
    } else if (line.startsWith('light-to-temperature map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        lightToTemperature.add(SeedLine.parse(lines[nextIndex]));
      }
    } else if (line.startsWith('temperature-to-humidity map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        temperatureToHumidity.add(SeedLine.parse(lines[nextIndex]));
      }
    } else if (line.startsWith('humidity-to-location map:')) {
      for (int nextIndex = index + 1; nextIndex < lines.length && lines[nextIndex].isNotEmpty; nextIndex++) {
        humidityToLocation.add(SeedLine.parse(lines[nextIndex]));
      }
    }
  }

  return SeedMap(
    seeds: seeds,
    seedToSoilMap: seedToSoil,
    soilToFertilizerMap: soilToFertilizer,
    fertilizerToWaterMap: fertilizerToWater,
    waterToLightMap: waterToLight,
    lightToTemperatureMap: lightToTemperature,
    temperatureToHumidityMap: temperatureToHumidity,
    humidityToLocationMap: humidityToLocation,
  );
}

int solve(List<String> lines) {
  final seedMap = parseData(lines);
  final results = seedMap.seeds.map(seedMap.seedToLocation).toList();

  return results.reduce((value, element) => value < element ? value : element);
}

const useGroundTruth = true;
final inputFile = useGroundTruth ? "./resources/dec5_ground_truth.txt" : "./resources/dec5.txt";

void main(List<String> args) async {
  final input = await readLinesFromFile(inputFile);
  final result = solve(input);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
