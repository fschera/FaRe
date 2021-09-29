import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:reso_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Tests will go here...
  testWidgets(
    "Not inputting a text and wanting to go to the display page shows "
        "an error and prevents from going to the display page.",
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp()); // Testing starts at the root widget in the widget tree
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();  // Wait for all the animations to finish
      expect(find.byType(TypingPage), findsOneWidget);
      expect(find.byType(DisplayPage), findsNothing);
      expect(find.text('Input at least one character'), findsOneWidget); // the text displayed by an error message on the TextFormField
    },
  );

  testWidgets(
    "After inputting a text, go to the display page which contains that same text "
        "and then navigate back to the typing page where the input should be clear",
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      final inputText = 'Hello there, this is an input.';
      await tester.enterText(find.byKey(Key('your-text-field')), inputText);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(TypingPage), findsNothing);
      expect(find.byType(DisplayPage), findsOneWidget);
      expect(find.text(inputText), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(TypingPage), findsOneWidget);
      expect(find.byType(DisplayPage), findsNothing);
      expect(find.text(inputText), findsNothing);
    },
  );
}
