import 'utils/files.dart';

int findTotalWinningOptions(int time, int distance) {
  int wins = 0;
  for (int chargeTime = 1; chargeTime < time; chargeTime++) {
    final travelTime = time - chargeTime;
    final travelDistance = travelTime * chargeTime;
    if (travelDistance > distance) {
      wins++;
    }
  }

  return wins;
}

int solve(List<String> input) {
  final times = RegExp(r'\d+').allMatches(input.first).map((e) => int.parse(e.group(0)!)).toList();
  final distances = RegExp(r'\d+').allMatches(input[1]).map((e) => int.parse(e.group(0)!)).toList();

  int combos = 1;
  for (int i = 0; i < times.length; i++) {
    final result = findTotalWinningOptions(times[i], distances[i]);
    combos *= result;
  }

  return combos;
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec6_ground_truth.txt" : "./resources/dec6.txt";

void main(List<String> args) async {
  final input = await readLinesFromFile(inputFile);
  final result = solve(input);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
