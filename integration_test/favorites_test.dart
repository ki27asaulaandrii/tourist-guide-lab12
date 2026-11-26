import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tourist_guide/main.dart' as app;
import 'package:tourist_guide/presentation/screens/favorites_screen.dart';

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Елемент не з\'явився вчасно: $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('додати місце в обране і побачити його на екрані Обране',
      (tester) async {
    app.main();
    await _waitFor(tester, find.text('Фонтан Рошен'));

    await tester.tap(find.byKey(const Key('favorite_button_1')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsWidgets);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byTooltip('Обране'));
    await tester.pumpAndSettle();

    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(FavoritesScreen),
        matching: find.text('Фонтан Рошен'),
      ),
      findsOneWidget,
    );
    expect(find.text('Обраних місць немає'), findsNothing);
  });
}
