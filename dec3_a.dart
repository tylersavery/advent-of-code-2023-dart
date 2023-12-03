import 'dart:math';

import 'utils/files.dart';

class Item {
  final int number;
  final int x;
  final int y;

  const Item({required this.number, required this.x, required this.y});

  int get width {
    return number.toString().length;
  }

  @override
  String toString() {
    return "$number ($x,$y) [$width]";
  }
}

class Symbol {
  final String char;
  final int x;
  final int y;

  const Symbol({required this.char, required this.x, required this.y});

  @override
  String toString() {
    return "$char ($x,$y)";
  }
}

(List<Item>, List<Symbol>) parse(List<String> values) {
  List<Item> items = [];
  List<Symbol> symbols = [];

  for (final rowEntry in values.asMap().entries) {
    final rowIndex = rowEntry.key;
    final rowValue = rowEntry.value;

    List<Match> matches = RegExp(r'\d+').allMatches(rowValue).toList();

    for (Match match in matches) {
      items.add(Item(number: int.parse(match.group(0)!), x: match.start, y: rowIndex));
    }

    for (final charEntry in rowValue.split("").asMap().entries) {
      final charIndex = charEntry.key;
      final charValue = charEntry.value;

      final isDigitOrPeriod = RegExp(r'^[\d.]$').hasMatch(charValue);
      if (!isDigitOrPeriod) {
        symbols.add(Symbol(char: charValue, x: charIndex, y: rowIndex));
      }
    }
  }

  return (items, symbols);
}

bool hasAdjacentSymbol(Item item, List<Symbol> symbols) {
  // check left
  if (symbols.indexWhere((s) => s.y == item.y && s.x == item.x - 1) != -1) {
    return true;
  }
  //check right
  if (symbols.indexWhere((s) => s.y == item.y && s.x == item.x + item.width) != -1) {
    return true;
  }

  //check above / below
  for (int x = item.x - 1; x <= item.x + item.width; x++) {
    if (symbols.indexWhere((s) => s.x == x && s.y == item.y - 1) != -1) {
      return true;
    }
    if (symbols.indexWhere((s) => s.x == x && s.y == item.y + 1) != -1) {
      return true;
    }
  }

  return false;
}

int solve(List<String> values) {
  final (items, symbols) = parse(values);

  final List<Item> validItems = [];

  for (final item in items) {
    final isTouchingSymbol = hasAdjacentSymbol(item, symbols);
    if (isTouchingSymbol) {
      validItems.add(item);
    }
  }

  return validItems.fold(0, (pv, v) => pv + v.number);
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
