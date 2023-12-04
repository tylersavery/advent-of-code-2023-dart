import 'utils/files.dart';

class Card {
  final List<int> winningNumbers;
  final List<int> myNumbers;
  final int copies;

  Card({required this.winningNumbers, required this.myNumbers, this.copies = 1});

  int get matchCount {
    int count = 0;
    for (final num in myNumbers) {
      if (winningNumbers.contains(num)) {
        count++;
      }
    }
    return count;
  }

  Card addCopies(int amount) {
    return Card(winningNumbers: winningNumbers, myNumbers: myNumbers, copies: copies + amount);
  }
}

int solve(List<String> rows) {
  List<Card> uniqueCards = [];
  for (final row in rows) {
    final d = row.split(":").last.trim();
    final winningNumbers = RegExp(r'\d+').allMatches(d.split("|").first).map((m) => int.parse(m.group(0)!)).toList();
    final myNumbers = RegExp(r'\d+').allMatches(d.split("|").last).map((m) => int.parse(m.group(0)!)).toList();

    final card = Card(winningNumbers: winningNumbers, myNumbers: myNumbers);
    uniqueCards.add(card);
  }

  int totalCards = 0;

  for (final entry in uniqueCards.asMap().entries) {
    final index = entry.key;
    final card = entry.value;

    totalCards += card.copies;

    for (int i = index + 1; i < index + card.matchCount + 1; i++) {
      final copy = uniqueCards[i].addCopies(card.copies);
      uniqueCards.removeAt(i);
      uniqueCards.insert(i, copy);
    }
  }

  return totalCards;
}

const useGroundTruth = false;
final inputFile = useGroundTruth ? "./resources/dec4_ground_truth.txt" : "./resources/dec4.txt";

void main(List<String> args) async {
  final values = await readLinesFromFile(inputFile);
  final result = solve(values);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
