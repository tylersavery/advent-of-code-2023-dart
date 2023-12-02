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

int solve(List<String> lines, int maxBlue, int maxRed, int maxGreen) {
  final games = lines.map((line) => Game.fromData(line)).toList();
  final List<int> possibleGameIds = [];

  for (final game in games) {
    bool gameIsPossible = true;

    for (final round in game.rounds) {
      if (round.blueCount > maxBlue || round.redCount > maxRed || round.greenCount > maxGreen) {
        gameIsPossible = false;
      }
    }

    possibleGameIds.add(gameIsPossible ? game.id : 0);
  }
  return possibleGameIds.fold(0, (previousValue, element) => previousValue + element);
}

const useGroundTruth = true;
final inputFile = useGroundTruth ? "./resources/dec2_ground_truth.txt" : "./resources/dec2.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values, 14, 12, 13);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
