import 'package:flutter_test/flutter_test.dart';
import 'package:atelier_cinq/app.dart';

void main() {
  testWidgets('App démarre correctement', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}