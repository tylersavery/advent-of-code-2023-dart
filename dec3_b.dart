import 'dart:math';

import 'utils/files.dart';

class Item {
  final int index;
  final int number;
  final int x;
  final int y;

  const Item({required this.index, required this.number, required this.x, required this.y});

  int get width {
    return number.toString().length;
  }

  @override
  String toString() {
    return "$number ($x,$y) {$width}";
  }
}

class Gear {
  final int x;
  final int y;

  const Gear({required this.x, required this.y});

  @override
  String toString() {
    return "($x,$y)";
  }
}

(List<Item>, List<Gear>) parse(List<String> values) {
  List<Item> items = [];
  List<Gear> gears = [];
  int itemIndex = 0;
  for (final rowEntry in values.asMap().entries) {
    final rowIndex = rowEntry.key;
    final rowValue = rowEntry.value;

    List<Match> matches = RegExp(r'\d+').allMatches(rowValue).toList();

    for (Match match in matches) {
      items.add(Item(index: itemIndex, number: int.parse(match.group(0)!), x: match.start, y: rowIndex));
      itemIndex++;
    }

    for (final charEntry in rowValue.split("").asMap().entries) {
      final charIndex = charEntry.key;
      final charValue = charEntry.value;

      if (charValue == "*") {
        gears.add(Gear(x: charIndex, y: rowIndex));
      }
    }
  }

  return (items, gears);
}

List<Item> getAdjacentItems(Gear gear, List<Item> items) {
  final List<Item> adjacentItems = [];

  //check left
  final leftIndex = items.indexWhere((item) => item.x + item.width == gear.x && item.y == gear.y);
  if (leftIndex >= 0) {
    adjacentItems.add(items[leftIndex]);
  }

  //check right
  final rightIndex = items.indexWhere((item) => item.x == gear.x + 1 && item.y == gear.y);
  if (rightIndex >= 0) {
    adjacentItems.add(items[rightIndex]);
  }

  //check above / below
  for (int x = gear.x - 1; x <= gear.x + 1; x++) {
    final aboveIndex = items.indexWhere((item) => item.x > x - item.width && item.x <= x && item.y == gear.y - 1);
    final belowIndex = items.indexWhere((item) => item.x > x - item.width && item.x <= x && item.y == gear.y + 1);

    if (aboveIndex >= 0) {
      final item = items[aboveIndex];

      if (adjacentItems.indexWhere((i) => i.index == item.index) < 0) {
        adjacentItems.add(item);
      }
    }

    if (belowIndex >= 0) {
      final item = items[belowIndex];

      if (adjacentItems.indexWhere((i) => i.index == item.index) < 0) {
        adjacentItems.add(item);
      }
    }
  }

  return adjacentItems;
}

int solve(List<String> values) {
  final (items, gears) = parse(values);

  int sum = 0;

  for (final gear in gears) {
    final adjacentItems = getAdjacentItems(gear, items);

    if (adjacentItems.length == 2) {
      sum += (adjacentItems.first.number * adjacentItems.last.number);
    }
  }

  return sum;
}

const useGroundTruth = true;
final inputFile = useGroundTruth ? "./resources/dec3_ground_truth.txt" : "./resources/dec3.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
