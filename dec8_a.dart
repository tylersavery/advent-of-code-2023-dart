import 'utils/files.dart';

class Node {
  final String location;
  final String left;
  final String right;

  const Node({
    required this.location,
    required this.left,
    required this.right,
  });

  @override
  String toString() {
    return "$location = ($left, $right)";
  }
}

Node parseLine(String line) {
  final location = line.split(" = ").first.trim();
  final moves = line.split(" = ").last.trim().replaceAll("(", "").replaceAll(")", "").split(", ").toList();

  return Node(location: location, left: moves.first, right: moves.last);
}

int solve(List<String> input) {
  final directions = input.first.trim().split("");

  input.removeAt(0);
  input.removeAt(0);

  final nodes = input.map((line) => parseLine(line)).toList();

  Node currentNode = nodes.firstWhere((node) => node.location == "AAA");
  int steps = 0;
  int i = 0;
  while (true) {
    steps++;

    int directionIndex = i % directions.length;
    if (directionIndex < 0) {
      directionIndex += directions.length;
    }

    final d = directions[directionIndex];

    late String moveTo;
    if (d == "L") {
      moveTo = currentNode.left;
    } else {
      moveTo = currentNode.right;
    }

    if (moveTo == "ZZZ") {
      break;
    }

    currentNode = nodes.firstWhere((node) => node.location == moveTo);
    i++;
  }

  return steps;
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec8_b_ground_truth.txt" : "./resources/dec8.txt";

void main(List<String> args) async {
  final input = await readLinesFromFile(inputFile);
  final result = solve(input);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
