import 'dart:math';

import 'utils/files.dart';

class Round {
  final int blueCount;
  final int redCount;
  final int greenCount;

  const Round({
    required this.blueCount,
    required this.redCount,
    required this.greenCount,
  });

  factory Round.fromData(String data) {
    int blueCount = 0;
    int redCount = 0;
    int greenCount = 0;

    final entries = data.split(",").map((e) => e.trim()).toList();

    for (final entry in entries) {
      if (entry.contains("blue")) {
        blueCount += int.parse(entry.replaceAll("blue", "").trim());
      }
      if (entry.contains("red")) {
        redCount += int.parse(entry.replaceAll("red", "").trim());
      }
      if (entry.contains("green")) {
        greenCount += int.parse(entry.replaceAll("green", "").trim());
      }
    }

    return Round(
      blueCount: blueCount,
      redCount: redCount,
      greenCount: greenCount,
    );
  }

  @override
  String toString() {
    return "BLUE: $blueCount | RED: $redCount | GREEN: $greenCount";
  }
}

class Game {
  final int id;
  final List<Round> rounds;

  const Game({
    required this.id,
    required this.rounds,
  });

  factory Game.fromData(String data) {
    final id = int.parse(data.split(":").first.replaceAll("Game ", ""));
    final roundsData = data.split(":").last.split(";").toList();
    return Game(id: id, rounds: roundsData.map((d) => Round.fromData(d)).toList());
  }

  @override
  String toString() {
    return "GAME $id: ${rounds.map((r) => r).join(' |**| ')} ";
  }
}

int solve(List<String> lines) {
  final games = lines.map((line) => Game.fromData(line)).toList();

  final List<int> gamePowers = [];

  for (final game in games) {
    int maxBlue = 0;
    int maxRed = 0;
    int maxGreen = 0;
    for (final round in game.rounds) {
      maxBlue = max(maxBlue, round.blueCount);
      maxRed = max(maxRed, round.redCount);
      maxGreen = max(maxGreen, round.greenCount);
    }

    gamePowers.add(maxBlue * maxRed * maxGreen);
  }
  return gamePowers.fold(0, (previousValue, element) => previousValue + element);
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec2_ground_truth.txt" : "./resources/dec2.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
