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

  bool get isStartingNode {
    return location.split("").last == "A";
  }

  bool get isEndingNode {
    return location.split("").last == "Z";
  }

  @override
  String toString() {
    return "$location = ($left, $right)";
  }
}

int findLCM(int a, int b) {
  int gcd = 1;
  for (int i = 1; i <= a && i <= b; ++i) {
    if (a % i == 0 && b % i == 0) {
      gcd = i;
    }
  }

  int lcm = (a * b) ~/ gcd;
  return lcm;
}

int findLCMOfList(List<int> numbers) {
  int lcm = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    lcm = findLCM(lcm, numbers[i]);
  }

  return lcm;
}

Node parseLine(String line) {
  final location = line.split(" = ").first.trim();
  final moves = line.split(" = ").last.trim().replaceAll("(", "").replaceAll(")", "").split(", ").toList();

  return Node(location: location, left: moves.first, right: moves.last);
}

int minSteps(List<String> directions, Node startingNode, List<Node> allNodes) {
  int steps = 0;
  int i = 0;

  while (true) {
    steps++;

    int directionIndex = i % directions.length;
    if (directionIndex < 0) {
      directionIndex += directions.length;
    }
    final d = directions[directionIndex];

    if (d == "L") {
      startingNode = allNodes.firstWhere((e) => e.location == startingNode.left);
    } else {
      startingNode = allNodes.firstWhere((e) => e.location == startingNode.right);
    }

    if (startingNode.isEndingNode) {
      break;
    }

    i++;
  }

  return steps;
}

int solve(List<String> input) {
  final directions = input.first.trim().split("");

  input.removeAt(0);
  input.removeAt(0);

  final nodes = input.map((line) => parseLine(line)).toList();

  final startingNodes = nodes.where((n) => n.isStartingNode).toList();

  final List<int> allSteps = [];
  for (final node in startingNodes) {
    final steps = minSteps(directions, node, nodes);
    allSteps.add(steps);
  }

  print(allSteps);

  return findLCMOfList(allSteps);
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec8_c_ground_truth.txt" : "./resources/dec8.txt";

void main(List<String> args) async {
  final input = await readLinesFromFile(inputFile);
  final result = solve(input);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
