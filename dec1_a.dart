import 'utils/files.dart';

(int, int) firstAndLastDigits(String value) {
  final matches = RegExp(r'\d').allMatches(value);
  if (matches.length < 1) {
    throw Exception("No matches found on value `$value`");
  }

  return (int.parse(matches.first.group(0)!), int.parse(matches.last.group(0)!));
}

int concatenateNumbers(int a, int b) {
  return int.parse("$a$b");
}

int solve(List<String> values) {
  final List<int> calibrationValues = [];

  for (final v in values) {
    final (first, last) = firstAndLastDigits(v);
    calibrationValues.add(concatenateNumbers(first, last));
  }

  return calibrationValues.fold(0, (int previousValue, int value) => previousValue + value);
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec1_a_ground_truth.txt" : "./resources/dec1.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
