import 'utils/files.dart';

const wordToNumberMapping = {
  'one': '1',
  'two': '2',
  'three': '3',
  'four': '4',
  'five': '5',
  'six': '6',
  'seven': '7',
  'eight': '8',
  'nine': '9',
  '1': '1',
  '2': '2',
  '3': '3',
  '4': '4',
  '5': '5',
  '6': '6',
  '7': '7',
  '8': '8',
  '9': '9',
};

String reverseString(String value) {
  return value.split("").reversed.join();
}

String firstDigit(String value) {
  RegExp regex = RegExp('(${wordToNumberMapping.keys.join("|")})');

  final matches = regex.firstMatch(value);
  if (matches == null) {
    throw Exception("no match found for value $value");
  }
  return matches.group(0)!;
}

String lastDigit(String value) {
  value = reverseString(value);
  RegExp regex = RegExp('(${wordToNumberMapping.keys.map((k) => reverseString(k)).join("|")})');

  final matches = regex.firstMatch(value);
  if (matches == null) {
    throw Exception("no match found for value $value");
  }
  return reverseString(matches.group(0)!);
}

int solve(List<String> values) {
  int sum = 0;
  for (final value in values) {
    final first = firstDigit(value);
    final last = lastDigit(value);

    if (!wordToNumberMapping.containsKey(first) || !wordToNumberMapping.containsKey(last)) {
      throw Exception("No mapping for $first or $last");
    }

    sum += int.parse("${wordToNumberMapping[first]}${wordToNumberMapping[last]}");
  }

  return sum;
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec1_b_ground_truth.txt" : "./resources/dec1.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
