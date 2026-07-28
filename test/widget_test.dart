import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';

void main() {
  testWidgets('opens splash and continues to welcome screen', (tester) async {
    await tester.pumpWidget(const GandaberundaApp());

    expect(find.text('GANDABERUNDA'), findsOneWidget);
    expect(find.text('Strength • Courage • Heritage'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
