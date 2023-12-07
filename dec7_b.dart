import 'dart:math';

import 'utils/files.dart';

const valueOrdering = [
  'A',
  'K',
  'Q',
  'T',
  '9',
  '8',
  '7',
  '6',
  '5',
  '4',
  '3',
  '2',
  'J',
];

class Hand {
  final List<String> cards;
  final List<String> replacedCards;
  final int bid;

  const Hand({
    required this.cards,
    required this.bid,
    required this.replacedCards,
  });

  double get entropy {
    Map<String, int> charCount = {};
    int totalChars = cards.length;

    replacedCards.forEach((String char) {
      charCount[char] = (charCount[char] ?? 0) + 1;
    });

    return -charCount.values.map((int count) {
      final d = count / totalChars;
      return d * (d == 0 ? 0 : -log(d));
    }).reduce((a, b) => a + b);
  }

  @override
  String toString() {
    return "${cards.join()} | $bid [$entropy]";
  }
}

bool cardHasHigherValue(String a, String b) {
  return valueOrdering.indexOf(a) < valueOrdering.indexOf(b) ? true : false;
}

int compareHands(Hand a, Hand b) {
  if (a.entropy == b.entropy) {
    for (int i = 0; i < a.cards.length; i++) {
      if (a.cards[i] == b.cards[i]) {
        continue;
      }
      return cardHasHigherValue(a.cards[i], b.cards[i]) ? -1 : 1;
    }
  }

  return a.entropy < b.entropy ? 1 : -1;
}

List<String> replaceJokers(List<String> cards) {
  int jokerCount = cards.where((c) => c == "J").length;

  if (jokerCount == 0) return cards;
  if (jokerCount == 5) return "AAAAA".split("");

  Map<String, int> frequencyMap = {};
  cards.where((c) => c != "J").forEach((card) {
    frequencyMap[card] = (frequencyMap[card] ?? 0) + 1;
  });

  final bestCard = frequencyMap.keys.reduce((a, b) => frequencyMap[a]! > frequencyMap[b]! ? a : b);

  for (var i = 0; i < jokerCount; i++) {
    cards = cards.join("").replaceFirst("J", bestCard).split("").toList();
  }

  return cards;
}

int solve(List<String> inputs) {
  final List<Hand> hands = [];

  for (final input in inputs) {
    final cards = input.split(" ").first.split("");
    final replacedCards = replaceJokers(cards);

    final bid = int.parse(input.split(" ").last);
    hands.add(
      Hand(cards: cards, bid: bid, replacedCards: replacedCards),
    );
  }

  hands.sort(compareHands);

  int score = 0;
  int multiplier = hands.length;
  for (final hand in hands) {
    score += (hand.bid * multiplier);
    multiplier--;
  }

  return score;
}

const useGroundTruth = true;
final inputFile = useGroundTruth ? "./resources/dec7_ground_truth.txt" : "./resources/dec7.txt";

void main(List<String> args) async {
  final input = await readLinesFromFile(inputFile);
  final result = solve(input);

  print("---!!!!----");
  print(result);
  print("---!!!!----");
}
