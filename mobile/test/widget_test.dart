import 'package:ahmed_elsayed_dawah/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AhmedElsayedApp renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AhmedElsayedApp());
    expect(find.text('أحمد السيد'), findsWidgets);
  });
}
