import 'utils/files.dart';

int solve(List<String> rows) {
  int totalPoints = 0;
  for (final row in rows) {
    final d = row.split(":").last.trim();
    final winningNumbers = RegExp(r'\d+').allMatches(d.split("|").first).map((m) => int.parse(m.group(0)!)).toList();
    final myNumbers = RegExp(r'\d+').allMatches(d.split("|").last).map((m) => int.parse(m.group(0)!)).toList();

    int points = 0;
    for (final num in myNumbers) {
      if (winningNumbers.contains(num)) {
        if (points == 0) {
          points = 1;
        } else {
          points *= 2;
        }
      }
    }
    totalPoints += points;
  }

  return totalPoints;
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec4_ground_truth.txt" : "./resources/dec4.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
