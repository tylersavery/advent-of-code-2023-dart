import 'utils/files.dart';

int solveLine(List<int> values) {
  List<List<int>> passes = [values];

  while (true) {
    final currentPass = passes.first;

    final List<int> diffs = [];
    for (int j = 1; j < currentPass.length; j++) {
      diffs.add(currentPass[j] - currentPass[j - 1]);
    }

    passes.insert(0, diffs);

    if (diffs.where((d) => d == 0).length == diffs.length) {
      break;
    }
  }

  for (int i = 0; i < passes.length - 1; i++) {
    passes[i + 1].insert(0, passes[i + 1].first - passes[i].first);
  }

  return passes.last.first;
}

int solve(List<String> inputs) {
  int sum = 0;
  for (final input in inputs) {
    sum += solveLine(input.split(" ").map((e) => int.parse(e.trim())).toList());
  }
  return sum;
}

const useGroundTruth = true;
final inputFile = useGroundTruth ? "./resources/dec9_ground_truth.txt" : "./resources/dec9.txt";

void main(List<String> args) async {
  final input = await readLinesFromFile(inputFile);
  final result = solve(input);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
