import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:newsflow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Guest Login -> News -> Detail -> Chat', (
    WidgetTester tester,
  ) async {
    app.main();

    await Future.delayed(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    final guestButton = find.text('Continue as guest');

    expect(guestButton, findsOneWidget);

    await tester.tap(guestButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Top News\nIndonesia'), findsOneWidget);

    final politicsCategoryButton = find.text('Politics').first;

    await tester.tap(politicsCategoryButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final firstNewsCard = find.byKey(Key('news_card')).first;

    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(firstNewsCard);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final bookmarkButton = find.byKey(Key('bookmark_button')).first;
    expect(bookmarkButton, findsOneWidget);

    await tester.tap(bookmarkButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final chatFab = find.byIcon(Icons.chat_bubble_rounded);
    expect(chatFab, findsOneWidget);

    await tester.tap(chatFab);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Chat Support'), findsOneWidget);

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'This is Integration Test');
    await tester.pump();

    final sendButton = find.byIcon(Icons.arrow_forward);
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    expect(find.text('This is Integration Test'), findsOneWidget);

    await Future.delayed(const Duration(seconds: 2));
  });
}
