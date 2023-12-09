import 'utils/files.dart';

int solveLine(List<int> values) {
  int i = 0;
  List<List<int>> passes = [values];

  while (true) {
    final currentPass = passes[i];

    final List<int> diffs = [];

    for (int j = 1; j < currentPass.length; j++) {
      diffs.add(currentPass[j] - currentPass[j - 1]);
    }

    passes.add(diffs);

    if (diffs.where((d) => d == 0).length == diffs.length) {
      break;
    }

    i++;
  }

  for (int i = passes.length - 1; i > 0; i--) {
    final p = passes[i];
    final previousPass = passes[i - 1];
    previousPass.add(p.last + previousPass.last);
  }

  return passes.first.last;
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
