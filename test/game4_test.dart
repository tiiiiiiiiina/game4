import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/game4.dart';

// Read the visible column so random apple placement does not affect the tests.
double columnOf(WidgetTester tester, String emoji) {
  final align = find
      .ancestor(of: find.text(emoji), matching: find.byType(Align))
      .first;
  return (tester.widget<Align>(align).alignment as Alignment).x;
}

Future<void> moveBasket(WidgetTester tester) async {
  await tester.tap(find.text('🍎 収穫ゲーム 🍎'));
  await tester.pump();
}

void main() {
  testWidgets('Basket moves between columns and catching an apple scores', (
    tester,
  ) async {
    await tester.pumpWidget(const GamePage());
    expect(columnOf(tester, '🧺'), -0.25);
    for (final column in [0.25, 0.75, 0.25, -0.25, -0.75, -0.25]) {
      await moveBasket(tester);
      expect(columnOf(tester, '🧺'), column);
    }
    while (columnOf(tester, '🧺') != columnOf(tester, '🍎')) {
      await moveBasket(tester);
    }
    await tester.pump(const Duration(milliseconds: 1600));
    expect(find.text('スコア：1  ミス：0 / 5'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Five misses end the game and restart resets it', (tester) async {
    await tester.pumpWidget(const GamePage());
    for (var miss = 1; miss <= 5; miss++) {
      if (columnOf(tester, '🧺') == columnOf(tester, '🍎')) {
        await moveBasket(tester);
      }
      await tester.pump(const Duration(milliseconds: 1600));
      expect(find.text('スコア：0  ミス：$miss / 5'), findsOneWidget);
    }
    expect(find.text('GAME OVER'), findsOneWidget);
    await tester.tap(find.text('🔁 もう一度'));
    await tester.pump();
    expect(find.text('GAME OVER'), findsNothing);
    expect(find.text('スコア：0  ミス：0 / 5'), findsOneWidget);
    expect(columnOf(tester, '🧺'), -0.25);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
