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
  final time = int.parse(input.first.replaceAll("Time:", "").replaceAll(" ", ""));
  final distance = int.parse(input[1].replaceAll("Distance:", "").replaceAll(" ", ""));

  final result = findTotalWinningOptions(time, distance);

  return result;
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
